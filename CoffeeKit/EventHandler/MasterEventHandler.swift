//
//  MasterEventHandler.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

/**
 * Class MasterEventHandler.
 * Load master or a custom slave with function(s). Call fetch* with your own function to finally call "fire()" and the custom slaves will fire.
 * When all slaves has been fired the master will fire. You can fire the master manually by calling "fire()" in the "fetchMaster()" -function.
 *
 * Example:
 // Initialize a MasterHandler
 let eventHandler = MasterEventHandler()
 // Load a slave by
 eventHandler.loadSlave("example", event: {
 (error) in
 if error == nil {
 // Do something with your fetched data
 } else {
 // Handle error
 }
 })
 
 // Fetch a slave by
 eventHandler.fetchSlave("")
 
 
 */
public class MasterEventHandler<T> {
    // MARK: PRIVATE VARS
    private var masterHandler : Event<T?>
    private var masterError : T?
    private var slaveErrors : [String: T]
    private var slaveHandler : [Int : SlaveEventHandler<T>]
    private var numberOfSlavesFired : Int
    
    // MARK: EXCLUSIVE PRIVATE VARS
    private var multiEventHandler: [MultiEventHandlerNames: MultiEventHandler<T>]
    
    // MARK: INIT FUNCITONS
    init() {
        masterHandler = Event<T?>()
        slaveHandler = [Int : SlaveEventHandler]()
        slaveErrors = [String: T]()
        multiEventHandler = [MultiEventHandlerNames: MultiEventHandler]()
        
        numberOfSlavesFired = 0
    }
    
    // MARK: PRIVATE FUNCTIONS
    /*
     * Resets the MasterEventHandler to when it was first initialized.
     */
    private func __reset() {
        self.masterHandler = Event<T?>()
        self.slaveHandler = [Int : SlaveEventHandler]()
        self.masterError = nil
        numberOfSlavesFired = 0
    }
    
    // MARK: PUBLIC FUNCTIONS
    /*
     * Loads the master with an event.
     */
    func loadMaster (_ event: @escaping (T?) -> Void) {
        masterHandler.addHandler(handler: event)
    }
    
    /*
     * Fires masters event if ready
     */
    func fireMasterIfReady() -> Bool {
        var result = false
        if self.numberOfSlavesFired == self.slaveHandler.count {
            self.masterHandler.raise(data: self.masterError)
            self.__reset()
            
            result = true
        }
        
        return result
    }
    
    /*
     * Loads a custom made slave with an event. If numberToFetch is set, then it wont fire until numberToFetch has been reached
     */
    func loadSlave (numberToFetch: Int = 1, event: @escaping (T?) -> Void) -> SlaveEventHandler<T> {
        let slave = SlaveEventHandler(masterHandler: self, numberToFetch: numberToFetch, event)
        
        self.slaveHandler[self.getNextSlaveId()] = slave
        
        return slave
    }
    
    func getNextSlaveId() -> Int {
        return self.slaveHandler.count
    }
    
    /*
     * Loads a multi load. Will not load if slaves doesn't exists. If the slaves been fired, this will fire. Returns true successfully loaded.
     */
    /*
    func loadAMultiSlave(slaveNames: [String], event: @escaping (T?) -> Void) -> Bool {
        var result = false
        
        if !slaveNames.isEmpty {
            var allIsLoaded = true
            var multiSlaveStringNames = Set<String>()
            // allIsLoaded will be false if one is false
            for slaveName in slaveNames {
                
                // Build name
                multiSlaveStringNames.insert(slaveName)
                
                // Check if slave exists
                if self.slaveHandler[slaveName] != nil && allIsLoaded {
                    allIsLoaded = true
                } else {
                    allIsLoaded = false
                }
            }
            
            // All is loaded, good to go
            if allIsLoaded {
                // Instansiate a name handler
                let multiSlaveName = MultiEventHandlerNames(names: multiSlaveStringNames)
                
                self.multiEventHandler[multiSlaveName] = MultiEventHandler(event: event)
                
                // Load 'em up
                for slaveName in slaveNames {
                    _ = self.multiEventHandler[multiSlaveName]!.addSlaveName(name: slaveName)
                }
                
                result = true
            }
        }
        
        
        return result
    } */
    
    /*
     * Will fire multiple shots if all assigned slaves to MultiEventHandler has been fired.
     */
    internal func fireMultipleSlavesIfReady(name: String) -> Bool {
        var result = false
        
        let multiEventHandlers = self.multiEventHandler.filter { (item) -> Bool in
            return item.0.names.contains(name)
        }
        
        if !multiEventHandlers.isEmpty {
            for multiEventHandler in multiEventHandlers {
                result = multiEventHandler.1.willFireIfAllFired(name: name)
                
                if result {
                    self.multiEventHandler.removeValue(forKey: multiEventHandler.0)
                }
            }
        }
        
        return result
    }
    
    /*
     * Runs the callback function and fires the slave. If all the slaves has been fired, the master will fire.
     */
    
    /*
    func fetchSlave (name: String, callback: (_ index: Int, _ fire: (T?) -> Void) -> Void) {
        if slaveHandler[name] != nil {
            if let slave = self.slaveHandler[name] {
                for i in 0..<slave.numberToFetch {
                    callback(i, { (error) in
                        
                        // Increase number of fetches to this slave
                        slave.increaseNumberOfFetches()
                        
                        if slave.isReady() {
                            _ = self.fireSlaveManually(name: name, error: error)
                            if error != nil {
                                self.masterError = error
                            }
                        }
                    })
                }
            }
        }
    }
    */
    /*
     * Loads the master with and event and then fires it on callback.
     */
    func loadAndFetchMaster(event: @escaping (T?) -> Void, callback: (_ fire: (T?) -> Void) -> Void) {
        loadMaster(event)
        fetchMaster(callback)
    }
    
    /*
     * Runs the callback function and fires the master.
     */
    func fetchMaster(_ callback: (_ fire: (T?) -> Void) -> Void) {
        callback({ (error) in
            self.masterHandler.raise(data: error)
            self.__reset()
        })
    }
    
    /*
     * Fires slave manually. Returns true if fired
     */
    /*
    func fireSlaveManually(name: String, error: T?) -> Bool {
        var result = false
        if let slave = self.slaveHandler[name] {
            slave.fire(error)
            
            if error != nil {
                self.slaveErrors[name] = error
            }
            
            self.numberOfSlavesFired += 1
            
            _ = self.fireMasterIfReady()
            _ = self.fireMultipleSlavesIfReady(name: name)
            
            result = true
        }
        
        return result
    }
    */
    /*
     * Returns all collected errors from Slaves
     */
    func getAllErrors() -> [String: T] {
        return self.slaveErrors
    }
}
