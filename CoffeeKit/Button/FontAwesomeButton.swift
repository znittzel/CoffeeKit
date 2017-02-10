//
//  FontAwesomeButton.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-10.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class FontAwesomeButton: UIButton {

    var is_init = false
    
    @IBInspectable public var faColor: UIColor = UIColor.white {
        didSet {
            updateIcon()
        }
    }
    
    @IBInspectable public var faSize: Int = 12 {
        didSet {
            updateIcon()
        }
    }
    
    @IBInspectable public var faString: String? {
        didSet {
            self.updateIcon()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !is_init {
            is_init = true
            
            // Update icon
            self.updateIcon()
        }
    }
    
    private func updateIcon() {
        guard let faString = self.faString else {
            return
        }
        
        guard let icon = UIImage.fontAwesomeIcon(code: faString, textColor: self.faColor, size: CGSize(width: self.faSize, height: self.faSize)) else {
            return
        }
        
        self.setImage(icon, for: .normal)
    }

}
