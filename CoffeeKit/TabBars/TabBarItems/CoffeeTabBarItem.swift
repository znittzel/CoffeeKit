//
//  CoffeeTabBarItem.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-03-15.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeTabBarItem: UITabBarItem {
    
    @IBInspectable public var faColor: UIColor = UIColor.black
    
    @IBInspectable public var faImageString : String? {
        didSet {
            self.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: faColor, size: CGSize.init(width: 15, height: 15))
            
            self.title = "Murva"
        }
    }
}
