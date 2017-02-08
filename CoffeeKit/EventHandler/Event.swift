//
//  Event.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

/*
 * Class Event<T>.
 * Is used by Master and SlaveEventHandler. Can be used as a custom event handler.
 */
class Event<T> {
    
    typealias EventHandler = (T) -> ()
    
    private var eventHandlers = [EventHandler]()
    
    func addHandler(handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
