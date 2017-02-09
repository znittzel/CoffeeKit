//
//  CoffeeResource.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-09.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class CoffeeResource {
    static let bundle = Bundle(identifier: "se.thryselius.CoffeeKit")!
    
    public static func getImage(name: String, type: String) -> UIImage? {
        let path = bundle.path(forResource: name, ofType: type)
        
        if path != nil {
            return UIImage(contentsOfFile: path!)
        } else {
            return nil
        }
    }
}
