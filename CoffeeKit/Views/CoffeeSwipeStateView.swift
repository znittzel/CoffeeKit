//
//  CoffeeSwipeStateView.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-10.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

public enum SwipeState {
    case Confirmed
    case Awaiting
    case Declined
}

@IBDesignable
public class CoffeeSwipeStateView: UIView {

    var is_init = false
    
    //MARK: INSPECTABLES
    @IBInspectable public var confirmed: String = "Confirmed" {
        didSet {
            self.confirmedLabel.text = confirmed
        }
    }
    
    @IBInspectable public var awaiting: String = "Awaiting" {
        didSet {
            self.awaitingLabel.text = awaiting
        }
    }
    
    @IBInspectable public var declined: String = "Declined" {
        didSet {
            self.declinedLabel.text = declined
        }
    }
    
    @IBInspectable public var confirmedColor: UIColor = UIColor.green {
        didSet {
            self.confirmedView.backgroundColor = confirmedColor
        }
    }
    
    @IBInspectable public var awaitingColor: UIColor = UIColor.yellow {
        didSet {
            self.awaitingView.backgroundColor = awaitingColor
        }
    }
    
    @IBInspectable public var declinedColor: UIColor = UIColor.red {
        didSet {
            self.declinedView.backgroundColor = declinedColor
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = 15 {
        didSet {
            self.updateFontSize()
        }
    }
    
    @IBInspectable public var deltaX: CGFloat = 5
    @IBInspectable public var duration: Double = 0.5
    
    public var state : SwipeState = .Confirmed
    
    var confirmedLabel = UILabel()
    var awaitingLabel = UILabel()
    var declinedLabel = UILabel()
    
    var confirmedView = UIView()
    var awaitingView = UIView()
    var declinedView = UIView()
    
    var confirmedViewHidden = false
    var awaitingViewHidden = true
    var declinedViewHidden = true
    
    var swipeLeft: UISwipeGestureRecognizer!
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Setup view
        self.setupView()
        
        // Setup recognizers
        self.setupRecognizers()
    }

    private func setupView() {
        var font: UIFont!
        
        if let f = UIFont(name: "White Chocolate Mint", size: self.fontSize) {
            font = f
        } else {
            font = UIFont(name: "Helvetica", size: self.fontSize)
        }
        
        // Declined view
        self.declinedView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.declinedView.backgroundColor = self.declinedColor
        self.declinedLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.declinedLabel.textAlignment = .center
        self.declinedLabel.textColor = .white
        self.declinedLabel.text = self.declined
        self.declinedLabel.font = font
        self.declinedView.addSubview(self.declinedLabel)
        
        // Awaiting view
        self.awaitingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width-deltaX, height: self.bounds.height)
        self.awaitingView.backgroundColor = self.awaitingColor
        self.awaitingView.isUserInteractionEnabled = true
        self.awaitingLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width-deltaX, height: self.bounds.height)
        self.awaitingLabel.textColor = .white
        self.awaitingLabel.textAlignment = .center
        self.awaitingLabel.text = self.awaiting
        self.awaitingLabel.font = font
        self.awaitingLabel.isUserInteractionEnabled = true
        self.awaitingView.addSubview(self.awaitingLabel)
        
        // Confirmed view
        self.confirmedView.frame = CGRect(x: 0, y: 0, width: self.bounds.width-2*self.deltaX, height: self.bounds.height)
        self.confirmedView.backgroundColor = self.confirmedColor
        self.confirmedView.isUserInteractionEnabled = true
        self.confirmedLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width-2*self.deltaX, height: self.bounds.height)
        self.confirmedLabel.textColor = .white
        self.confirmedLabel.textAlignment = .center
        self.confirmedLabel.text = self.confirmed
        self.confirmedLabel.font = font
        self.confirmedLabel.isUserInteractionEnabled = true
        self.confirmedView.addSubview(self.confirmedLabel)
        
        
        self.addSubview(self.declinedView)
        self.addSubview(self.awaitingView)
        self.addSubview(self.confirmedView)
    }
    
    private func updateFontSize() {
        let f = self.declinedLabel.font.withSize(self.fontSize)
        self.declinedLabel.font = f
        self.awaitingLabel.font = f
        self.confirmedLabel.font = f
    }
    
    private func setupRecognizers() {
        var swipeConfirmed = UISwipeGestureRecognizer(target: self, action: #selector(respondToConfirmedSwipeGesture(_:)))
        swipeConfirmed.direction = .left
        self.confirmedView.addGestureRecognizer(swipeConfirmed)
        
        var swipeAwaitingRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToAwaitingSwipeGesture(_:)))
        swipeAwaitingRight.direction = .right
        self.awaitingView.addGestureRecognizer(swipeAwaitingRight)
        
        var swipeAwaitingLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToAwaitingSwipeGesture(_:)))
        swipeAwaitingLeft.direction = .left
        self.awaitingView.addGestureRecognizer(swipeAwaitingLeft)
        
        var swipeDeclined = UISwipeGestureRecognizer(target: self, action: #selector(respondToDeclinedSwipeGesture(_:)))
        swipeDeclined.direction = .right
        self.declinedView.addGestureRecognizer(swipeDeclined)
    }
    
    func respondToConfirmedSwipeGesture(_ gesture: UIGestureRecognizer) {
        guard self.declinedViewHidden && self.awaitingViewHidden && !self.confirmedViewHidden else {
            return
        }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                self.declinedViewHidden = true
                self.awaitingViewHidden = false
                self.confirmedViewHidden = true
                
                UIView.animate(withDuration: self.duration,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                    self.confirmedView.frame.origin.x -= (self.confirmedView.bounds.width-self.deltaX)
                               },
                               completion: { (done) in
                                
                               })
                break
            default:
                break
            }
        }
    }
    
    func respondToAwaitingSwipeGesture(_ gesture: UIGestureRecognizer) {
        guard self.declinedViewHidden && !self.awaitingViewHidden && self.confirmedViewHidden else {
            return
        }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.declinedViewHidden = true
                self.awaitingViewHidden = true
                self.confirmedViewHidden = false
                
                UIView.animate(withDuration: self.duration,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                    self.confirmedView.frame.origin.x += (self.confirmedView.bounds.width-self.deltaX)
                               },
                               completion: { (done) in
                                
                               })
                break
            case UISwipeGestureRecognizerDirection.left:
                self.declinedViewHidden = false
                self.awaitingViewHidden = true
                self.confirmedViewHidden = true
                
                UIView.animate(withDuration: self.duration,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                    self.awaitingView.frame.origin.x -= (self.confirmedView.bounds.width-self.deltaX*2)
                               },
                               completion: { (done) in
                                
                               })
                break
            default:
                break
            }
        }
    }
    
    func respondToDeclinedSwipeGesture(_ gesture: UIGestureRecognizer) {
        guard !self.declinedViewHidden && self.awaitingViewHidden && self.confirmedViewHidden else {
            return
        }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.declinedViewHidden = true
                self.awaitingViewHidden = false
                self.confirmedViewHidden = true
                
                UIView.animate(withDuration: self.duration,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                    self.awaitingView.frame.origin.x += (self.confirmedView.bounds.width-self.deltaX*2)
                               },
                               completion: { (done) in
                                //
                               })
                break
            
            default:
                break
            }
        }
    }
}
