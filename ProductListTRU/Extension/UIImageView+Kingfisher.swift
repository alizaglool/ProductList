//
//  UIImageView+extension.swift
//  OrderPro
//
//  Created by Ahmed Nasr on 27/12/2022.
//

import UIKit
import Kingfisher

protocol imageDownloaded {
    func setImage(url: URL?, placeholder: UIImage?)
}

//MARK: - set image with kingfisher -
//
extension UIImageView: imageDownloaded {
    func setImage(url: URL?, placeholder: UIImage? = nil) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
