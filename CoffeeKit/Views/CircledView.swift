//
//  CircledView.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-10.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CircledView: UIView {

    var is_init = false
    
    @IBInspectable public var hasBorder: Bool = false {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.updateView()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !is_init {
            is_init = true
            
            // Setup view
            self.setupView()
        }
    }

    func setupView() {
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        self.clipsToBounds = true
    }
    
    func updateView() {
        if hasBorder {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        } else {
            self.layer.borderWidth = 0
        }
    }
}
