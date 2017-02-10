//
//  CoffeeButton.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-08.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeButton: UIButton {

    var is_init = false
    
    @IBInspectable public var cornerRadius: Double = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(self.cornerRadius)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !is_init {
            is_init = true
            
            self.setupView()
        }
    }
    
    private func setupView() {
        self.layer.cornerRadius = CGFloat(self.cornerRadius)
    }
}
