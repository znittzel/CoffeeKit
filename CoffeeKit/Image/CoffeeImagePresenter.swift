//
//  CoffeeImagePresenter.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-09.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeImagePresenter: UIView {

    @IBInspectable public var maxDX : CGFloat = CGFloat(1.5) {
        didSet {
            updateImageViews()
        }
    }
    
    var is_init = false
    var imageViews = [CircledImageView]()
    var example_isInit = false
    
    public var doNotUseExamples = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !is_init {
            self.is_init = true
            
            // Setup view
            self.updateImageViews()
            
            if self.imageViews.count == 0 && !doNotUseExamples {
                self.loadExampleImages()
            }
        }
    }
    
    private func loadExampleImages() {
        guard let pic1 = CoffeeResource.getImage(name: "profilepic1", type: "jpg") else {
            return
        }
        
        guard let pic2 = CoffeeResource.getImage(name: "profilepic2", type: "jpg") else {
            return
        }
        
        guard let pic3 = CoffeeResource.getImage(name: "profilepic3", type: "jpg") else {
            return
        }
        
        guard let pic4 = CoffeeResource.getImage(name: "profilepic4", type: "jpg") else {
            return
        }
        
        guard let pic5 = CoffeeResource.getImage(name: "profilepic5", type: "jpg") else {
            return
        }
        
        let picViews = [
            CircledImageView(image: pic1),
            CircledImageView(image: pic2),
            CircledImageView(image: pic3),
            CircledImageView(image: pic4),
            CircledImageView(image: pic5)
        ]
        
        //arc4random_uniform(UInt32(picViews.count))
        for i in 0...Int(3) {
            self.imageViews.append(picViews[i])
        }
        
        self.updateImageViews()
        self.example_isInit = true
    }
    
    public func updateImageViews() {
        let imgCount = self.imageViews.count
        guard imgCount > 0 else {
            return
        }
        
        let halvBoundsWidth = self.bounds.width/2
        
        let width = self.bounds.height
        let halfWidth = width / 2
        let y = CGFloat(0)
        var xDelta = width / self.maxDX
        
        if xDelta*CGFloat(imgCount-1)+width > self.bounds.width {
            xDelta = (self.bounds.width - width) / CGFloat(imgCount-1)
        }
        
        let startX = (halvBoundsWidth-halfWidth)-(CGFloat(imgCount-1)*xDelta/2)
        
        for index in 0..<self.imageViews.count {
            let imgView = self.imageViews[index]
            
            // Remove imgView from super view
            imgView.removeFromSuperview()
            
            // Redo rect for imgView
            imgView.frame = CGRect(x: startX+(xDelta * CGFloat(index)), y: y, width: width, height: self.bounds.height)
            
            // Add it back as subView
            self.addSubview(imgView)
        }
    }
    
    public func add(imageView: CircledImageView) {
        self.checkAndRemoveExampleViews()
        
        self.imageViews.append(imageView)
        self.updateImageViews()
    }
    
    public func add(imageViews: [CircledImageView]) {
        self.checkAndRemoveExampleViews()
        
        for img in imageViews {
            self.imageViews.append(img)
        }
        
        self.updateImageViews()
    }
    
    public func removeImageViews() {
        self.imageViews.removeAll()
        
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    public func checkAndRemoveExampleViews() {
        if example_isInit {
            self.imageViews.removeAll()
            example_isInit = false
        }
    }

}
