//
//  ProductCollectionViewCell.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 29/03/2025.
//

import UIKit
import UICurrency
import Networking

final class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var subView: ShadowBackgroundView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.cornerRadius = 10
    }
    
    func configure(with model: ProductCellViewModel) {
        productImageView.setImage(url: URL(string: model.image ?? ""))
        productPriceLabel.text = model.price
        productTitleLabel.text = model.title
        productDescriptionLabel.text = model.description
    }
}

// MARK: - Product ViewModel -

struct ProductCellViewModel {
    let image, title, description, price: String?
    
    init(product: Product) {
        self.image = product.image
        self.description = product.description
        self.title = product.title
        self.price = "\(product.price) $"
    }
}

// MARK: - Identifier Cell -

extension ProductCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "ProductCollectionViewCell", bundle: nil)
    }
    static let identifier = "ProductCollectionViewCell"
}

