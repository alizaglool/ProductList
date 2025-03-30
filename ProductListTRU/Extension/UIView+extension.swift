//
//  File.swift
//  
//
//  Created by Zahgloul on 07/05/2023.
//

import UIKit

//MARK: - apply shadow for view -

extension UIView {
    func setShadow(shadowColor: UIColor = .gray, shadowOpacity: Float = 0.9,
                   shadowRadius: CGFloat = 1, shadowOffset: CGSize = CGSize(width: 0, height: -2)) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    func applyCornerRadius(cornerRadius: CGFloat = 20) {
        layer.cornerRadius = cornerRadius
    }
}
