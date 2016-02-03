//
//  ViewController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        throwGranade()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func throwGranade() {        
       // let layer = SpriteLayerC()
        
        let sprite = UIImage(named: "bang-sprite.png")//?.CGImage!
        
        //layer.contents =  sprite
        
        let size  = CGSizeMake(100, 100)
        
        
        let layer = SpriteLayerC.init(
            andAnimationSettings: sprite,
            sampleSize: size,
            animationFrameStart: 1,
            animationFrameEnd: 82,
            animationDuration: 1,
            lanimationRepeatCount: 1)
        
//        let normaizedWidth: CGFloat = CGFloat(size.width) /   CGFloat(CGImageGetWidth(sprite))
//        let normalizedHeight: CGFloat = CGFloat(size.height) /  CGFloat(CGImageGetHeight(sprite))
//        
//        let normalizedSize = CGSizeMake(normaizedWidth, normalizedHeight)
//        
//        layer.bounds = CGRect(x: 0,y: 0, width: 50 , height: 50 )
//        layer.contentsRect = CGRectMake(0, 0, normalizedSize.width , normalizedSize.height )
//        
//        let animation = CABasicAnimation.init(keyPath: "sampleIndex")
//        
//        print(animation)
//        
//        animation.fromValue = 1
//        animation.toValue = 82
//        animation.duration = 3
//        animation.repeatCount = 2
//        
//        print(animation.fromValue)
//        
//        print(animation.keyPath)
//        
       self.view.layer.addSublayer(layer)
//        
//        layer.addAnimation(animation, forKey: nil)
//        
//        layer.contentsScale = 20
        
        layer.frame = CGRect(x: 200, y: 200, width: 50, height:50)
        
        
        let handle = setTimeout(5, block: { () -> Void in
           layer.playAnimationAgain()
          
        })
        
    }
    
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: "main", userInfo: nil, repeats: false)
    }
}

