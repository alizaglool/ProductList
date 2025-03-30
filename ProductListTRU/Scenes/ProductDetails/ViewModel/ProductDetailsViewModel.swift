//
//  ProductDetailsViewModel.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//

import Foundation
import Networking
import RxSwift
import RxCocoa

protocol ProductDetailsViewModelType {
    var title: Observable<String> { get }
    var price: Observable<Double> { get }
    var description: Observable<String> { get }
    var category: Observable<String> { get }
    var image: Observable<String> { get }

    func setProduct(_ product: Product)
}

final class ProductDetailsViewModel: ProductDetailsViewModelType {

    private let titleRelay = BehaviorRelay<String>(value: "")
    private let priceRelay = BehaviorRelay<Double>(value: 0.0)
    private let descriptionRelay = BehaviorRelay<String>(value: "")
    private let categoryRelay = BehaviorRelay<String>(value: "")
    private let imageRelay = BehaviorRelay<String>(value: "")
    
    var title: Observable<String> { titleRelay.asObservable() }
    var price: Observable<Double> { priceRelay.asObservable() }
    var description: Observable<String> { descriptionRelay.asObservable() }
    var category: Observable<String> { categoryRelay.asObservable() }
    var image: Observable<String> { imageRelay.asObservable() }

    func setProduct(_ product: Product) {
        titleRelay.accept(product.title)
        priceRelay.accept(product.price)
        descriptionRelay.accept(product.description)
        categoryRelay.accept(product.category)
        imageRelay.accept(product.image)
    }
}
