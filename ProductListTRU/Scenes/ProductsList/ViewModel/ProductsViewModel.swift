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
}

final class ProductsViewModel: ProductsViewModelType {
    
    var api: ProductAPIProtocol = ProductAPI()
    
    private var productsRelay = PublishSubject<[Product]>()
    var products: Observable<[Product]> {
        productsRelay.asObservable()
    }
    
    var activityIndicatorStatus: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    var errorService: PublishSubject = PublishSubject<Error>()
    
}

extension ProductsViewModel {
    func fetchProducts() {
        activityIndicatorStatus.accept(true)
        
        api.getProducts(completion: { [weak self] result in
            guard let self = self else { return }
            self.activityIndicatorStatus.accept(false)
            
            switch result {
            case .success(let response):
                guard let response = response, !response.isEmpty else { return }
                
                self.productsRelay.onNext(response)
            case .failure(let error):
                self.errorService.onNext(error)
            }
        })
    }
}
