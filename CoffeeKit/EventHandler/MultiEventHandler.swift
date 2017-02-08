//
//  MultiEventHandler.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

public func == (lmeh: MultiEventHandlerNames, rmeh: MultiEventHandlerNames) -> Bool {
    return lmeh.hashValue == rmeh.hashValue
}
public class MultiEventHandlerNames : Hashable {
    public var names = Set<String>()
    public var hashValue: Int
    
    init(names: Set<String>) {
        self.names = names
        self.hashValue = names.hashValue
    }
}

class MultiEventHandler<T> {
    // MARK: PRIVATE VARS
    private var multipleSlavesFired: [String : Bool]
    private var slaveEventHandler: SlaveEventHandler<T>
    
    // MARK: INIT FUNCTIONS
    init(masterHandler: MasterEventHandler<T>, event: @escaping (T?) -> Void) {
        self.multipleSlavesFired = [String : Bool]()
        self.slaveEventHandler = SlaveEventHandler(masterHandler: masterHandler, event)
    }
    
    // MARK: FUNCIONS
    /*
     * Adds a slave name to multipleSlavesFired. Returns true if appending is successfull.
     */
    func addSlaveName(name: String) -> Bool {
        var result = false
        if multipleSlavesFired[name] == nil {
            multipleSlavesFired[name] = false
            
            result = true
        }
        
        return result
    }
    
    /*
     * Tells multipleSlavesFired that *name* -slave has fired. If all has been fired, this slaveEventHandler will fire.
     */
    func willFireIfAllFired(name: String) ->Bool {
        var result = false
        
        if self.multipleSlavesFired[name] != nil {
            self.multipleSlavesFired[name] = true
            
            let shotsBeenFired = multipleSlavesFired.filter({ (shot) -> Bool in
                return shot.1
            })
            
            if shotsBeenFired.count == self.multipleSlavesFired.count {
                self.slaveEventHandler.fireManually()
                
                result = true
            }
        }
        
        return result
    }
}
