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
    
    @IBInspectable public var duration: Double = 0.3
    
    public var state : SwipeState = .Confirmed
    
    private var deltaX: CGFloat = 5
    
    private var confirmedLabel = UILabel()
    private var awaitingLabel = UILabel()
    private var declinedLabel = UILabel()
    
    private var confirmedView = UIView()
    private var awaitingView = UIView()
    private var declinedView = UIView()
    
    private var currentState: SwipeState = .Confirmed
    
    var actions = [(SwipeState) -> Void]()
    
    public var disabled = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Setup view
        self.setupView()
        
        // Setup recognizers
        if !disabled {
            self.setupRecognizers()
        }
    }
    
    /**
     Adds function to execute when current state is changed by gui / animated change.
     
     - Author:
     Rikard Olsson
     
     - returns:
     Void
     
     - parameters:
     - action: Function with a SwipeState parameter.
     */
    public func add(_ action: @escaping (_ currentState: SwipeState) -> Void) {
        self.actions.append(action)
    }
    
    /**
     Will set view into state when layout subviews. E.g. in viewDidLoad in your UIViewController.
     
     - Author:
     Rikard Olsson
     
     - returns:
     Bool indicating if it was set or not. Use forceSet() if false.
     
     - parameters:
        - state: A SwipeState, Confirmed, Declined or Awaiting
    */
    public func preSet(_ state: SwipeState) -> Bool {
        if !is_init {
            self.currentState = state
            return true
        } else {
            return false
        }
    }
    
    /**
     Animates to givin state.
     
     - Author:
     Rikard Olsson
     
     - returns:
     Void
     
     - parameters:
     - state: A SwipeState, Confirmed, Declined or Awaiting
     */
    private func animate(_ to: SwipeState) {
        switch to {
        case .Awaiting:
            switch self.currentState {
            case .Awaiting:
                return

            case .Confirmed:
                self.animate({ 
                    self.confirmedView.frame.origin.x -= (self.bounds.width-self.deltaX)
                }, { _ in
                    self.currentState = .Awaiting
                    self.fireActions()
                })
                break

            case .Declined:
                self.animate({
                    self.awaitingView.frame.origin.x += (self.bounds.width-self.deltaX*2)
                }, { _ in
                    self.currentState = .Awaiting
                    self.fireActions()
                })
                break
            }
            break
        case .Confirmed:
            switch self.currentState {
            case .Awaiting:
                self.animate({ 
                    self.confirmedView.frame.origin.x += (self.bounds.width-self.deltaX)
                }, { _ in
                    self.currentState = .Confirmed
                    self.fireActions()
                })
                break
                
            case .Confirmed:
                return
                
            case .Declined:
                self.animate({ 
                    self.awaitingView.frame.origin.x += (self.bounds.width-self.deltaX*2)
                }, { _ in
                    self.currentState = .Awaiting
                    self.animate(.Confirmed)
                    self.fireActions()
                })
                break
            }
            break
        case .Declined:
            switch self.currentState {
            case .Awaiting:
                self.animate({ 
                    self.awaitingView.frame.origin.x -= (self.bounds.width-self.deltaX*2)
                }, { _ in
                    self.currentState = .Declined
                    self.fireActions()
                })
                break
                
            case .Confirmed:
                self.animate({ 
                    self.confirmedView.frame.origin.x -= (self.bounds.width-self.deltaX)
                }, { _ in
                    self.currentState = .Awaiting
                    self.animate(.Declined)
                    self.fireActions()
                })
                break
                
            case .Declined:
                return
            }
            break
        }
    }
    
    /**
     Forces the view into the givin state.
     
     - Author:
     Rikard Olsson
     
     - returns:
     Void
     
     - parameters:
     - state: A SwipeState, Confirmed, Declined or Awaiting
     */
    public func forceSet(_ state: SwipeState) {
        let rects = self.getRectsBy(state)
        
        self.declinedView.frame = rects["Declined"]!
        self.awaitingView.frame = rects["Awaiting"]!
        self.confirmedView.frame = rects["Confirmed"]!
        
        self.currentState = state
    }
    
    private func animate(_ this: @escaping () -> Void, _ completion: ((_ done: Bool) -> Void)?) {
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: this,
                       completion: { (done) in
                        if completion != nil {
                            completion!(done)
                        }
        })
    }
    
    private func fireActions() {
        for action in self.actions {
            action(self.currentState)
        }
    }
    
    private func getRect(_ x: CGFloat = 0) -> CGRect {
        return CGRect(x: x, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    private func getRectsByCurrentState() -> [String:CGRect] {
        var rects = [String: CGRect]()
        
        switch self.currentState {
        case .Awaiting:
            rects["Confirmed"] = self.getRect(-(self.bounds.width-self.deltaX))
            rects["Awaiting"] = self.getRect()
            break
        case .Confirmed:
            rects["Confirmed"] = self.getRect()
            rects["Awaiting"] = self.getRect()
            break
        case .Declined:
            rects["Confirmed"] = self.getRect(-(self.bounds.width-self.deltaX))
            rects["Awaiting"] = self.getRect(-(self.bounds.width-self.deltaX*2))
            break
        }
        
        rects["Declined"] = self.getRect()
        
        return rects
    }
    
    private func getRectsBy(_ state: SwipeState) -> [String:CGRect] {
        var rects = [String: CGRect]()
        
        switch state {
        case .Awaiting:
            rects["Confirmed"] = self.getRect(-(self.bounds.width-self.deltaX))
            rects["Awaiting"] = self.getRect()
            break
        case .Confirmed:
            rects["Confirmed"] = self.getRect()
            rects["Awaiting"] = self.getRect()
            break
        case .Declined:
            rects["Confirmed"] = self.getRect(-(self.bounds.width-self.deltaX))
            rects["Awaiting"] = self.getRect(-(self.bounds.width-self.deltaX*2))
            break
        }
        
        rects["Declined"] = self.getRect()
        
        return rects
    }
    
    private func setupView() {
        var font: UIFont!
        
        font = UIFont(name: "System", size: self.fontSize)

        var rects = self.getRectsByCurrentState()
        
        // Declined view
        self.declinedView.frame = rects["Declined"]!
        self.declinedView.backgroundColor = self.declinedColor
        self.declinedLabel.frame = self.getRect()
        self.setShadowLayer(self.declinedView.layer)
        self.declinedLabel.textAlignment = .center
        self.declinedLabel.textColor = .white
        self.declinedLabel.text = self.declined
        self.declinedLabel.font = font
        self.declinedView.addSubview(self.declinedLabel)
        
        // Awaiting view
        self.awaitingView.frame = rects["Awaiting"]!
        self.awaitingView.backgroundColor = self.awaitingColor
        self.awaitingView.isUserInteractionEnabled = true
        self.awaitingLabel.frame = self.getRect()
        self.setShadowLayer(self.awaitingView.layer)
        self.awaitingLabel.textColor = .white
        self.awaitingLabel.textAlignment = .center
        self.awaitingLabel.text = self.awaiting
        self.awaitingLabel.font = font
        self.awaitingLabel.isUserInteractionEnabled = true
        self.awaitingView.addSubview(self.awaitingLabel)
        
        // Confirmed view
        self.confirmedView.frame = rects["Confirmed"]!
        self.confirmedView.backgroundColor = self.confirmedColor
        self.confirmedView.isUserInteractionEnabled = true
        self.setShadowLayer(self.confirmedView.layer)
        self.confirmedLabel.frame = self.getRect()
        self.confirmedLabel.textColor = .white
        self.confirmedLabel.textAlignment = .center
        self.confirmedLabel.text = self.confirmed
        self.confirmedLabel.font = font
        self.confirmedLabel.isUserInteractionEnabled = true
        self.confirmedView.addSubview(self.confirmedLabel)
        
        
        self.addSubview(self.declinedView)
        self.addSubview(self.awaitingView)
        self.addSubview(self.confirmedView)
        
        self.is_init = true
    }
    
    private func updateFontSize() {
        let f = self.declinedLabel.font.withSize(self.fontSize)
        self.declinedLabel.font = f
        self.awaitingLabel.font = f
        self.confirmedLabel.font = f
    }
    
    private func setShadowLayer(_ layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 1
    }
    
    private func setupRecognizers() {
        let swipeConfirmed = UISwipeGestureRecognizer(target: self, action: #selector(respondToConfirmedSwipeGesture(_:)))
        swipeConfirmed.direction = .left
        self.confirmedView.addGestureRecognizer(swipeConfirmed)
        
        let swipeAwaitingRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToAwaitingSwipeGesture(_:)))
        swipeAwaitingRight.direction = .right
        self.awaitingView.addGestureRecognizer(swipeAwaitingRight)
        
        let swipeAwaitingLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToAwaitingSwipeGesture(_:)))
        swipeAwaitingLeft.direction = .left
        self.awaitingView.addGestureRecognizer(swipeAwaitingLeft)
        
        let swipeDeclined = UISwipeGestureRecognizer(target: self, action: #selector(respondToDeclinedSwipeGesture(_:)))
        swipeDeclined.direction = .right
        self.declinedView.addGestureRecognizer(swipeDeclined)
    }
    
    func respondToConfirmedSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            
            case UISwipeGestureRecognizerDirection.left:
                self.animate(.Awaiting)
                break
            
            default:
                break
            }
        }
    }
    
    func respondToAwaitingSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            
            case UISwipeGestureRecognizerDirection.right:
                self.animate(.Confirmed)
                break
                
            case UISwipeGestureRecognizerDirection.left:
                self.animate(.Declined)
                break
            
            default:
                break
            }
        }
    }
    
    func respondToDeclinedSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            
            case UISwipeGestureRecognizerDirection.right:
                self.animate(.Awaiting)
                break
            
            default:
                break
            }
        }
    }
}
