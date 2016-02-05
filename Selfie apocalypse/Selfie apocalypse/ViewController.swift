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
    
    var touchedSelfie: Selfie?
    
    var currentSelfieZindex = 1000
    var selfiesKilledCount = 0
    var absorbtionsTillDeath = 3
    var selfies = Set<Selfie>()
    
    @IBOutlet weak var selfiesKilledLabel: UILabel!
    
    @IBOutlet weak var granades: GranadesStatusBar!
    
    @IBOutlet weak var hearts: LivesStatusBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupGestures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGestures(){
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleDoubleTap:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delegate = self
        self.view.addGestureRecognizer(doubleTapRecognizer)
        
        let longRecognizer = UILongPressGestureRecognizer(target: self, action:Selector("handleLongPress:"))
        longRecognizer.delegate = self
        self.view.addGestureRecognizer(longRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action:Selector("handleSwipe:"))
        swipeRecognizer.direction = [UISwipeGestureRecognizerDirection.Left,  UISwipeGestureRecognizerDirection.Right]
        swipeRecognizer.delegate = self
        self.view.addGestureRecognizer(swipeRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:Selector("handlePinch:"))
        pinchRecognizer.delegate = self
        self.view.addGestureRecognizer(pinchRecognizer)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        let touchPosition = recognizer.locationInView(self.view)
        
        let afectedFelfie = self.getTouchedSelfie(touchPosition)
        
        if(afectedFelfie != nil){
            
            self.killSelfie(afectedFelfie!)
        }
        
        print("tap")
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        
        print(recognizer.scale)
        
        if recognizer.scale > 3{
            
            let touchPosition = recognizer.locationInView(self.view)
            let afectedFelfie = self.getTouchedSelfie(touchPosition)
            
            if(afectedFelfie != nil){
                
                self.killSelfie(afectedFelfie!)
            }
        }
        
        print("pinch")
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        let touchPosition = recognizer.locationInView(self.view)
        
        let afectedFelfie = self.getTouchedSelfie(touchPosition)
        
        if(afectedFelfie != nil){
            
            self.killSelfie(afectedFelfie!)
        }
        
        print("swipe")
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let touchPosition = recognizer.locationInView(self.view)
        
        let afectedFelfie = self.getTouchedSelfie(touchPosition)
        
        if(afectedFelfie != nil){
            
            self.killSelfie(afectedFelfie!)
        }
        
        print("long")
    }
    
    @IBAction func throwGranade(sender: AnyObject) {
        
        
        //self.hearts.takeHeart()
        drawSelfie()
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
    
    func animateSelfie(selfieToAnimate: Selfie){
        
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
                        
                        self.absorbHeart(selfieToAnimate)
                })
        })
    }
    
    func getTouchedSelfie(pointOfTouch: CGPoint) -> Selfie?{
        
        for selfie in self.selfies{
            // print("x: \(selfie.frame.origin.x), y:\(selfie.frame.origin.y))")
            
            if CGRectContainsPoint(selfie.layer.presentationLayer()!.frame	, pointOfTouch){
                
                touchedSelfie = selfie
                
                return selfie
                //  selfie.removeFromSuperview()
                //  self.selfies.remove(selfie)
            }
        }
        
        return nil
    }
    
    func killSelfie(selfieToKill: Selfie){
        
        self.animateSelfieDeath(selfieToKill)
        selfieToKill.removeFromSuperview()
        self.selfies.remove(selfieToKill)
        ++self.selfiesKilledCount
        self.selfiesKilledLabel.text = String(self.selfiesKilledCount)
    }
    
    func animateSelfieDeath(selfieToAnimate: Selfie){
        
        let sprite = UIImage(named: "bang-sprite.png")
        let size = CGSize(width: 100, height: 100)
        
        let bombSpriteLayer = SpriteLayerC.init(
            imageAndAnimationSettings: sprite,
            sampleSize: size,
            animationFrameStart: 1,
            animationFrameEnd: 82,
            animationDuration: 2,
            lanimationRepeatCount: 0)
        
        let currentSelfieSize = selfieToAnimate.layer.presentationLayer()!.frame.size
        let currentSelfiePosition = selfieToAnimate.layer.presentationLayer()!.position
  
        
        bombSpriteLayer.frame = CGRect(
            x: currentSelfiePosition.x - (currentSelfieSize.width / 2),
            y: currentSelfiePosition.y - (currentSelfieSize.height / 2),
            width: currentSelfieSize.width,
            height:currentSelfieSize.height)
        
        bombSpriteLayer.zPosition = selfieToAnimate.layer.zPosition
        
        self.view.layer.addSublayer(bombSpriteLayer!)
        
        bombSpriteLayer.playAnimationAgain()
    }
    
    func absorbHeart(absorbBySelfie: Selfie){
        if(self.selfies.contains(absorbBySelfie as Selfie)){
            self.hearts.takeHeart()
            --self.absorbtionsTillDeath
            
            // TODO: remove selfie and make som signal about that (sond  and animation)
        }
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first
//        
//        let firstTouch: CGPoint = touch!.locationInView(self.view!)
//        
//        // let selfiesCount = self.selfies.count
//        
//        for selfie in self.selfies{
//            print("x: \(selfie.frame.origin.x), y:\(selfie.frame.origin.y))")
//            
//            if CGRectContainsPoint(selfie.layer.presentationLayer()!.frame	, firstTouch){
//                
//                touchedSelfie = selfie
//                
//                //  selfie.removeFromSuperview()
//                //  self.selfies.remove(selfie)
//                
//            }
//        }
//        
//        print("began")
//        
//        super.touchesBegan(touches, withEvent: event)
//    }
    
    // Detects device shake
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            print("shaked")
            self.throwSomeGranage()
        }
    }
    
    func throwSomeGranage(){
        self.granades.throwGranade()
        
        for selfie in self.selfies{
            self.killSelfie(selfie)
        }
    }
    
    
    //    func gestureRecognizer(_: UIGestureRecognizer,
    //        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
    //            return true
    //    }
    
    
    
    // TODO: make it global function
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: "main", userInfo: nil, repeats: false)
    }
}

