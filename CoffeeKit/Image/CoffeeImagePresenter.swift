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

    var is_init = false
    var imageViews = [CircledImageView]()
    var example_isInit = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !is_init {
            self.is_init = true
            
            // Setup view
            self.updateImageViews()
            
            if self.imageViews.count == 0 {
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
        
        let pic1View = CircledImageView(image: pic1)
        let pic2View = CircledImageView(image: pic2)
        let pic3View = CircledImageView(image: pic3)
        let pic4View = CircledImageView(image: pic4)
        let pic5View = CircledImageView(image: pic5)
        
        self.imageViews.append(pic1View)
        self.imageViews.append(pic2View)
        self.imageViews.append(pic3View)
        self.imageViews.append(pic4View)
        self.imageViews.append(pic5View)
        
        self.updateImageViews()
        self.example_isInit = true
    }
    
    public func updateImageViews() {
        guard self.imageViews.count > 0 else {
            return
        }
        
        let width = self.bounds.height
        let y = CGFloat(0)
        let xDelta = self.bounds.width / CGFloat(self.imageViews.count)
        
        for index in 0..<self.imageViews.count {
            let imgView = self.imageViews[index]
            
            // Remove imgView from super view
            imgView.removeFromSuperview()
            
            // Redo rect for imgView
            imgView.frame = CGRect(x: (xDelta * CGFloat(index)), y: y, width: width, height: self.bounds.height)
            
            // Add it back as subView
            self.addSubview(imgView)
        }
    }
    
    public func addImageView(imgView: CircledImageView) {
        if example_isInit {
            self.imageViews.removeAll()
            example_isInit = false
        }
        
        self.imageViews.append(imgView)
        self.updateImageViews()
    }

}
