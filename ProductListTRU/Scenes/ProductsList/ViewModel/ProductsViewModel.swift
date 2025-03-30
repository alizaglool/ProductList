//
//  ProductsViewModel.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 29/03/2025.
//

import Foundation
import Networking
import RxSwift
import RxCocoa

protocol ProductsViewModelType: AnyObject {
    var products: Observable<[Product]> { get }
    var activityIndicatorStatus: BehaviorRelay<Bool> { get set }
    var errorService: PublishSubject<Error> { get set }
    
    func fetchProducts()
    func fetchNextPage()
}

final class ProductsViewModel: ProductsViewModelType {
    
    private let pageSize = 7
    private var offset = 0
    private var isLoadingMore = false
    private var allLoaded = false
    
    private let api: ProductAPIProtocol
    private let cacheService: ProductCacheServiceProtocol
    private let networkMonitor: NetworkMonitorServiceProtocol
    
    private var productIDs: Set<Int> = []
    private var productsList: [Product] = []
    
    private var productsRelay = PublishSubject<[Product]>()
    var products: Observable<[Product]> { productsRelay.asObservable() }
    
    var activityIndicatorStatus = BehaviorRelay<Bool>(value: false)
    var errorService = PublishSubject<Error>()
    
    init(api: ProductAPIProtocol = ProductAPI(),
         cacheService: ProductCacheServiceProtocol = ProductCacheService(),
         networkMonitor: NetworkMonitorServiceProtocol = NetworkMonitorService()) {
        self.api = api
        self.cacheService = cacheService
        self.networkMonitor = networkMonitor
    }
}

extension ProductsViewModel {
    func fetchProducts() {
        guard networkMonitor.isConnected else {
            errorService.onNext(NetworkError.noConnection)
            sendCachedDataIfAvailable()
            return
        }
        
        offset = 0
        allLoaded = false
        productsList = []
        productIDs = []
        activityIndicatorStatus.accept(true)
        
        api.getProducts(limit: pageSize, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicatorStatus.accept(false)
            
            switch result {
            case .success(let response):
                guard let response = response, !response.isEmpty else {
                    self.sendCachedDataIfAvailable()
                    return
                }
                
                let uniqueProducts = response.filter { !self.productIDs.contains($0.id) }
                self.productIDs.formUnion(uniqueProducts.map { $0.id })
                
                self.productsList = uniqueProducts
                self.productsRelay.onNext(self.productsList)
                self.cacheService.save(products: uniqueProducts)
                self.offset += self.pageSize
                
            case .failure(let error):
                self.sendCachedDataIfAvailable()
                self.errorService.onNext(error)
            }
        }
    }
    
    private func sendCachedDataIfAvailable() {
        if let cached = cacheService.load() {
            self.productsRelay.onNext(cached)
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
            
            switch result {
            case .success(let response):
                guard let response = response, !response.isEmpty else {
                    self.allLoaded = true
                    return
                }
                
                let newProducts = response.filter { !self.productIDs.contains($0.id) }
                self.productIDs.formUnion(newProducts.map { $0.id })
                
                self.productsList.append(contentsOf: newProducts)
                self.productsRelay.onNext(self.productsList)
                self.cacheService.save(products: self.productsList)
                self.offset += self.pageSize
                
            case .failure(let error):
                self.errorService.onNext(error)
            }
        }
    }
}
