//
//  UIView.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

extension UIView {
    func makeShadow() {
        clipsToBounds = false
        layer.shadowColor = R.color.shadow()?.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
    }

    func applyGradient(startColor: CGColor, endColor: CGColor) {
        let gradient = CAGradientLayer()

        gradient.colors = [startColor, endColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
