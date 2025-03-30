//
//  ShadowBackgroundView.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 29/03/2025.
//


import UIKit

final class ShadowBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    private func initCommon() {
        setShadow(shadowRadius: 0.5, shadowOffset: CGSize(width: 0, height: -2))
    }
}
