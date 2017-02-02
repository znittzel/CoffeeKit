//
//  CoffeeError.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-01.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

public class CoffeeError {
    var key: String
    var value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
