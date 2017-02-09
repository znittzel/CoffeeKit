//
//  CircledImageView.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-09.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CircledImageView: UIImageView {

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
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }

}
