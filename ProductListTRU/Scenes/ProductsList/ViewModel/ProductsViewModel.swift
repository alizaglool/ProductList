import Foundation
import Networking
import RxSwift
import RxCocoa

protocol ProductsViewModelType: AnyObject {
    var products: Observable<[Product]> { get }
    var activityIndicatorStatus: BehaviorRelay<Bool> { get }
    var errorService: PublishSubject<Error> { get }
    var productsIsEmpty: Bool { get }

    func fetchProducts()
    func fetchNextPage()
}

final class ProductsViewModel: ProductsViewModelType {

    // MARK: - Pagination
    private let pageSize = 7
    private var offset = 0
    private var isLoadingMore = false
    private var allLoaded = false

    // MARK: - Dependencies
    private let api: ProductAPIProtocol
    private let cacheService: ProductCacheServiceProtocol
    private let networkMonitor: NetworkMonitorServiceProtocol

    // MARK: - Data
    private var productIDs: Set<Int> = []
    private var productsList: [Product] = []

    // MARK: - Observables
    private let productsRelay = BehaviorRelay<[Product]>(value: [])
    var products: Observable<[Product]> { productsRelay.asObservable() }

    let activityIndicatorStatus = BehaviorRelay<Bool>(value: false)
    let errorService = PublishSubject<Error>()

    var productsIsEmpty: Bool {
        return productsRelay.value.isEmpty
    }

    // MARK: - Init
    init(api: ProductAPIProtocol = ProductAPI(),
         cacheService: ProductCacheServiceProtocol = ProductCacheService(),
         networkMonitor: NetworkMonitorServiceProtocol = NetworkMonitorService()) {
        self.api = api
        self.cacheService = cacheService
        self.networkMonitor = networkMonitor
    }

    // MARK: - Public Methods
    func fetchProducts() {
        activityIndicatorStatus.accept(true)

        // Step 1: Show cached data immediately if available
        sendCachedDataIfAvailable()

        // Step 2: If offline, stop here
        guard networkMonitor.isConnected else {
            activityIndicatorStatus.accept(false)
            errorService.onNext(NetworkError.noConnection)
            return
        }

        // Step 3: Proceed with fresh API fetch
        resetState()

        api.getProducts(limit: pageSize, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicatorStatus.accept(false)
            self.handleResult(result, isInitialLoad: true)
        }
    }

    func fetchNextPage() {
        guard networkMonitor.isConnected else {
            errorService.onNext(NetworkError.noConnection)
            return
        }

        guard !isLoadingMore, !allLoaded else { return }
        isLoadingMore = true

        api.getProducts(limit: pageSize, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingMore = false
            self.handleResult(result, isInitialLoad: false)
        }
    }

    // MARK: - Private Helpers
    private func resetState() {
        offset = 0
        allLoaded = false
        productsList = []
        productIDs = []
    }

    private func sendCachedDataIfAvailable() {
        guard let cached = cacheService.load(), !cached.isEmpty else { return }

        if productsList.isEmpty {
            productIDs = Set(cached.map { $0.id })
            productsList = cached
            productsRelay.accept(cached)
        }
    }

    private func handleResult(_ result: Result<[Product]?, Error>, isInitialLoad: Bool) {
        switch result {
        case .success(let response):
            guard let response = response, !response.isEmpty else {
                if isInitialLoad {
                    sendCachedDataIfAvailable()
                }
                allLoaded = true
                return
            }

            let newProducts = response.filter { !productIDs.contains($0.id) }
            productIDs.formUnion(newProducts.map { $0.id })

            if isInitialLoad {
                productsList = newProducts
            } else {
                productsList.append(contentsOf: newProducts)
            }

            productsRelay.accept(productsList)
            cacheService.save(products: productsList)
            offset += pageSize

        case .failure(let error):
            if isInitialLoad {
                sendCachedDataIfAvailable()
            }
            errorService.onNext(error)
        }
    }
}
