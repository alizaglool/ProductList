//
//  ProductsViewController.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 29/03/2025.
//

import UIKit
import RxSwift
import UICurrency
import Networking

final class ProductsViewController: UIViewController {
    
    @IBOutlet private weak var productCollectionView: UICollectionView!
    
    // MARK: - Init

    private let viewModel: ProductsViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: ProductsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("De-Init Products List")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProductCollectionView()
        bindLoadingToViewModel()
        bindTruckSubCollectionViewToViewModel()
        bindToErrorService()
    }
}

// MARK: - Setup Truck main Collection View -

extension ProductsViewController {

    private func setupProductCollectionView() {
        productCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        productCollectionView.dataSource = nil
        
        productCollectionView.register(ProductsCollectionViewCell.nib(),
                                         forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
    }
}

//MARK: - bind Loading To view Model -

extension ProductsViewController {
    private func bindLoadingToViewModel() {
        viewModel.activityIndicatorStatus
            .subscribe(onNext: { [weak self] (isLoading) in
                guard let self = self else { return }
                Indicator.createIndicator(on: self, start: isLoading)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Bind Product list Collection View To View Model -

extension ProductsViewController {

    private func bindTruckSubCollectionViewToViewModel() {
        viewModel.products
            .observe(on: MainScheduler.instance)
            .bind(to: productCollectionView.rx.items(cellIdentifier: ProductsCollectionViewCell.identifier, cellType: ProductsCollectionViewCell.self)){ (row, model, cell) in
                cell.configure(with: ProductCellViewModel(product: model))
            }
            .disposed(by: disposeBag)
        
        productCollectionView.rx.modelSelected(Product.self)
            .subscribe(onNext: { [weak self] selectedProduct in
                guard let self else { return }
                getProductDetails(for: selectedProduct)
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchProducts()
    }
    
    private func getProductDetails(for product: Product) {
        let detailViewModel = ProductDetailsViewModel()
        detailViewModel.setProduct(product)
        
        let detailsVC = ProductDetailsViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - Bind to Error Service -

extension ProductsViewController {
    private func bindToErrorService() {
        viewModel.errorService
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                Alert.failedToConnectWithServerAlert(on: self)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // 16 left + 16 right insets
        return CGSize(width: width, height: 120) // Adjust height based on your cell content
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
