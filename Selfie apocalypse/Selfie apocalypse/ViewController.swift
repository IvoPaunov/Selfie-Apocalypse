//
//  ViewController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit
//import GLKit

import Foundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        let touchPosition =   recognizer.locationInView(self.view)
        
        
        for selfie in self.selfies{
            print("x: \(selfie.frame.origin.x), y:\(selfie.frame.origin.y))")
            
            if CGRectContainsPoint(selfie.layer.presentationLayer()!.frame	, touchPosition){
                
                touchedSelfie = selfie
                
                //  selfie.removeFromSuperview()
                //  self.selfies.remove(selfie)
                
                print("figrata")
                
            }
        }
        
        print("tap")
    }
    
    var touchedSelfie: Selfie?
    
    var currentSelfieZindex = 1000
    var selfiesKilledCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        tapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        let longRecognizer = UILongPressGestureRecognizer(target: self, action:Selector("handleLongPress:"))
        longRecognizer.delegate = self
        self.view.addGestureRecognizer(longRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action:Selector("swipeLeft:"))
        swipeRecognizer.direction = [UISwipeGestureRecognizerDirection.Left,  UISwipeGestureRecognizerDirection.Right]
        swipeRecognizer.delegate = self
        self.view.addGestureRecognizer(swipeRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:Selector("handlePinch:"))
        pinchRecognizer.delegate = self
        self.view.addGestureRecognizer(pinchRecognizer)
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        
        let touchPosition =   recognizer.locationInView(self.view)
                  print(recognizer.scale)
        
        for selfie in self.selfies{
          //  print("x: \(selfie.frame.origin.x), y:\(selfie.frame.origin.y))")
            
  
            
            if CGRectContainsPoint(selfie.layer.presentationLayer()!.frame	, touchPosition){
                
                touchedSelfie = selfie
                
                //  selfie.removeFromSuperview()
                //  self.selfies.remove(selfie)
            
                print("figrata    -pinch")
                
            }
        }
        
        print("pinch")
    }
    
    
    func swipeLeft(sender: AnyObject) {
        
        if (touchedSelfie != nil) {
            
            self.selfies.remove(touchedSelfie!)
            touchedSelfie?.removeFromSuperview()
            touchedSelfie = nil
        }
        
        print("swipe")
    }
    
    
    
    
    func handleLongPress(sender: AnyObject) {
        
        print("long")
    }
    
    var selfies = Set<Selfie>()
    
    @IBOutlet weak var selfiesKilledLabel: UILabel!
    
    @IBOutlet weak var granades: GranadesStatusBar!
    
    @IBOutlet weak var hearts: LivesStatusBar!
    
    @IBAction func throwGranade(sender: AnyObject) {
        
        self.granades.throwGranade()
        //self.hearts.takeHeart()
        drawSelfie()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  drawSelfie(){
        
        let selfie = Selfie()
        let randomX = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width  - 100) + 50))
        let randomY = CGFloat(arc4random_uniform(20) + 30)
        
        
        
        
        
        let frame = CGRectMake(randomX, randomY, randomY, randomY)
        selfie.frame = frame
        selfie.backgroundColor = UIColor.clearColor()
        selfie.layer.zPosition = CGFloat(currentSelfieZindex)
        selfie.alpha = 0
        selfie.userInteractionEnabled = true
        //        selfie.layer.cornerRadius = selfie.bounds.size.width / 2
        //        selfie.layer.masksToBounds = true
        currentSelfieZindex--
        
        
        //                let tapRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        //                tapRecognizer.delegate = self
        //                selfie.addGestureRecognizer(tapRecognizer)
        
        selfies.insert(selfie)
        self.view.addSubview(selfie)
        
        animateSelfie(selfie)
    }
    
    func animateSelfie(selfieToAnimate: UIView){
        
        let screenWidth = UIScreen.mainScreen().bounds
        let width = screenWidth.size.width
        
        UIView.animateWithDuration(2,
            // delay:  0,
            // options: [UIViewAnimationOptions.AllowUserInteraction , UIViewAnimationOptions.AllowAnimatedContent],
            animations: {
                selfieToAnimate.alpha = 1
            },
            completion: { finish in
                
                UIView.animateWithDuration(15,
                    delay: 0.5,
                    options: [UIViewAnimationOptions.AllowUserInteraction,
                        UIViewAnimationOptions.AllowAnimatedContent],
                    animations: {
                        selfieToAnimate.alpha = 1
                        selfieToAnimate.transform = CGAffineTransformMakeScale(5, 5)
                        selfieToAnimate.layer.position.y = CGFloat(screenWidth.size.height - 100)
                        let randmX = CGFloat(arc4random_uniform(UInt32(width + 300)))
                        selfieToAnimate.layer.position.x = randmX - 150
                    },
                    completion: { finish in
                        // selfieToAnimate.transform = CGAffineTransformIdentity
                        //selfieToAnimate.removeFromSuperview()
                        
                        if(self.selfies.contains(selfieToAnimate as! Selfie)){
                            self.hearts.takeHeart()
                        }
                })
        })
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let firstTouch: CGPoint = touch!.locationInView(self.view!)
        
        // let selfiesCount = self.selfies.count
        
        for selfie in self.selfies{
            print("x: \(selfie.frame.origin.x), y:\(selfie.frame.origin.y))")
            
            if CGRectContainsPoint(selfie.layer.presentationLayer()!.frame	, firstTouch){
                
                touchedSelfie = selfie
                
                //  selfie.removeFromSuperview()
                //  self.selfies.remove(selfie)
                
            }
        }
        
        print("began")
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            print("shaked")        }
    }
    
    
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: "main", userInfo: nil, repeats: false)
    }
}

