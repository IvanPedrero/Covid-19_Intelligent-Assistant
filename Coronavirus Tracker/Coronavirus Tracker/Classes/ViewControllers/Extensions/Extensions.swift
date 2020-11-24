//
//  Extensions.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 23/11/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func stylizeContainerView(roundBorder:Bool = true) {
        if roundBorder {
            self.layer.cornerRadius = 10
        }
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
    
    func stylizeButton() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
    }
    
}

extension UITextField {
    
    func stylizeTextField() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
    }
}
