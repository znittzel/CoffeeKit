//
//  CoffeeCountDownLabel.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-12-08.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeCountLabel: UILabel {
    
    @IBInspectable public var start : Int = 3 {
        didSet {
            self.counter = start
        }
    }
    @IBInspectable public var end : Int = 0
    @IBInspectable public var speed : UInt32 = 1
    
    internal var counter : Int = 0
    internal var timer : Timer!
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.text = "\(self.start)"
    }
    
    public func startAnimateCount(callback: @escaping () -> Void) {
        self.reset()
        
        self.isHidden = false
        self.text = "\(self.start)"
        
        if self.start > self.end {
            self.countDown(callback: callback)
        } else {
            self.countUp(callback: callback)
        }
    }
    
    private func countDown(callback: @escaping () -> Void) {
        DispatchQueue(label: "com.app.queue", qos: .background, target: nil).async {
            
            while(true) {
                sleep(self.speed)
                if self.counter > self.end {
                    self.counter -= 1
                    
                    DispatchQueue.main.async {
                        self.text = "\(self.counter)"
                    }
                } else {
                    break
                }
            }
            
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    
    private func countUp(callback: @escaping () -> Void) {
        DispatchQueue(label: "com.app.queue", qos: .background, target: nil).async {
            
            while(true) {
                sleep(self.speed)
                if self.counter < self.end {
                    self.counter += 1
                    
                    DispatchQueue.main.async {
                        self.text = "\(self.counter)"
                    }
                } else {
                    break
                }
            }
            
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    
    private func reset() {
        self.counter = self.start
    }
}
