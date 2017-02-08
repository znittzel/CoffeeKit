//
//  CoffeeTextField.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-08.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeTextField: UITextField {

    @IBInspectable public var placeholderColor : UIColor = UIColor.white {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    var is_init = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !is_init {
            self.is_init = true
            
            // Setup view
            self.setupView()
        }
    }
    
    private func setupView() {
        self.updatePlaceholder()
        self.setBorder()
        self.textAlignment = .center
    }
    
    private func updatePlaceholder() {
        if let placeholderText = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName : self.placeholderColor])
        }
    }

    private func setBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
