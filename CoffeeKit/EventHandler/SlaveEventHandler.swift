//
//  SlaveEventHandler.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation
/*
 * Class SlaveEventHandler.
 * Is used by MasterEventHandler. Can be used as a single object and would work the way same as a MasterEventHandler -slave.
 */
public class SlaveEventHandler<T> : Hashable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: SlaveEventHandler<T>, rhs: SlaveEventHandler<T>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    private var eventHandler = Event<T?>()
    private var masterEventHandler: MasterEventHandler<T>
    
    public var numberToFetch = 1
    public var numberOfFetches = 0
    
    public var hashValue: Int
    
    public var id: Int
    
    public init(_ masterHandler: MasterEventHandler<T>) {
        self.masterEventHandler = masterHandler
        
        self.id = masterHandler.getNextSlaveId()
        self.hashValue = self.id.hashValue
    }
    
    /*
     * Loads an event on creating object.
     */
    public convenience init(masterHandler: MasterEventHandler<T>, _ event: @escaping (T?) -> Void) {
        self.init(masterHandler)
        
        self.load(event)
    }
    
    /*
     * Loads an event on creating object.
     */
    public convenience init(masterHandler: MasterEventHandler<T>, numberToFetch: Int, _ event: @escaping (T?) -> Void) {
        self.init(masterHandler: masterHandler, event)
        self.numberToFetch = numberToFetch
    }
    
    /*
     * Loads an event.
     */
    func load(_ event: @escaping (T?) -> Void) {
        eventHandler.addHandler(handler: event)
    }
    
    /*
     * Fires all the loaded events.
     */
    func fire(_ error: T?) {
        eventHandler.raise(data: error)
    }
    
    func setNumberToFetch(numberToFetch: Int) {
        self.numberToFetch = numberToFetch
    }
    
    /*
     * Increases the number of fetches that has been made by this Slave Event
     */
    func increaseNumberOfFetches() {
        self.numberOfFetches += 1
    }
    
    /*
     * Checking if slave is ready
     */
    func isReady() -> Bool {
        return self.numberOfFetches == self.numberToFetch
    }
    
    /*
     * Fireing events manually
     */
    func fireManually() {
        eventHandler.raise(data: nil)
    }
}
