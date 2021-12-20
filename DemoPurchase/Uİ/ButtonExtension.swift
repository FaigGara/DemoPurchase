//
//  ButtonExtension.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 18.12.2021.
//

import UIKit

extension UIButton {

    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil, cornerRadius: 0)
    }


    func applyGradient(colours: [UIColor], locations: [NSNumber]?, cornerRadius: CGFloat?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = cornerRadius ?? 0
        self.layer.insertSublayer(gradient, at: 0)
    }

}
