//
//  ProductDetailsViewController.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//

import UIKit
import RxSwift
import UICurrency

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Init

    private let viewModel: ProductDetailsViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: ProductDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("De-Init Products Details")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
    }
}

// MARK: - setup View

extension ProductDetailsViewController {
    private func setupView() {
        subView.applyCornerRadius()
    }
}

// MARK: - Binding Data to UI

extension ProductDetailsViewController {
    private func bindViewModel() {
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.price
            .map { "$\($0)" }
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.category
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.image
            .subscribe(onNext: { [weak self] imageUrl in
                self?.productImageView.setImage(url: URL(string: imageUrl))
            })
            .disposed(by: disposeBag)
    }
}
