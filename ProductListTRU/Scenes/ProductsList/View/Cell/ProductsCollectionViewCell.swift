//
//  ProductsCollectionViewCell.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//

import UIKit
import Networking

final class ProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var subView: ShadowBackgroundView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productCategoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.cornerRadius = 10
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        productImageView.isSkeletonable = true
        productTitleLabel.isSkeletonable = true
        productCategoryLabel.isSkeletonable = true
        productPriceLabel.isSkeletonable = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productTitleLabel.text = nil
        productCategoryLabel.text = nil
        productPriceLabel.text = nil
    }
    
    func configure(with model: ProductCellViewModel) {
        productImageView.setImage(url: URL(string: model.image ?? ""))
        productPriceLabel.text = model.price
        productTitleLabel.text = model.title
        productCategoryLabel.text = model.category
    }
}

// MARK: - Product ViewModel -

struct ProductCellViewModel {
    let image, title, category, price: String?
    
    init(product: Product) {
        self.image = product.image
        self.category = product.category
        self.title = product.title
        self.price = "\(product.price) $"
    }
}

// MARK: - Identifier Cell -

extension ProductsCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
    }
    static let identifier = "ProductsCollectionViewCell"
}

