//
//  ViewController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

import Foundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    var utils = Utils()
    
    var touchedSelfie: Selfie?
    
    var currentSelfieZindex = HUGE
    var selfiesKilledCount = 0
    var absorbtionsTillDeath = 3
    var granadesLeft = 3
    var currentSelfiesWaveSpeed = 15
    var currentSelfieReproductionInterval: Float = 3
    var selfies = Set<Selfie>()
    var loopHandler: NSTimer?
    
    @IBOutlet weak var weaponForLastSelfieImageView: UIImageView!
    
    @IBOutlet weak var selfiesKilledLabel: UILabel!
    
    @IBOutlet weak var granades: GranadesStatusBar!
    
    @IBOutlet weak var hearts: LivesStatusBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestures()
        // TODO: Add countdown
        self.loopHandler?.invalidate()
        self.loopHandler = nil
        self.gameLoop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGestures(){
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action:Selector("handleDoubleTap:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delegate = self
        self.view.addGestureRecognizer(doubleTapRecognizer)
        
        let longRecognizer = UILongPressGestureRecognizer(
            target: self,
            action:Selector("handleLongPress:"))
        longRecognizer.delegate = self
        self.view.addGestureRecognizer(longRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(
            target: self,
            action:Selector("handleSwipe:"))
        swipeRecognizer.direction = [UISwipeGestureRecognizerDirection.Left,  UISwipeGestureRecognizerDirection.Right]
        swipeRecognizer.delegate = self
        self.view.addGestureRecognizer(swipeRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(
            target: self,
            action:Selector("handlePinch:"))
        pinchRecognizer.delegate = self
        self.view.addGestureRecognizer(pinchRecognizer)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        let touchPosition = recognizer.locationInView(self.view)
        
        let afectedFelfies = self.getTouchedSelfies(touchPosition)
        
        if(afectedFelfies.count > 0){
            
            for selfie in afectedFelfies{
                if selfie.selfieType == SelfieTipe.Pike_Susceptible {
                    self.slaySelfie(selfie)
                }
            }
        }
        
        print("tap")
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        
        print(recognizer.scale)
        
        if recognizer.scale > 3{
            
            let touchPosition = recognizer.locationInView(self.view)
            
            let afectedFelfies = self.getTouchedSelfies(touchPosition)
            
            if(afectedFelfies.count > 0){
                
                for selfie in afectedFelfies{
                    if selfie.selfieType == SelfieTipe.Nunchaku_Susceptible {
                        self.slaySelfie(selfie)
                    }
                }
            }        }
        
        print("pinch")
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        let touchPosition = recognizer.locationInView(self.view)
        
        let afectedFelfies = self.getTouchedSelfies(touchPosition)
        
        if(afectedFelfies.count > 0){
            
            for selfie in afectedFelfies{
                if selfie.selfieType == SelfieTipe.Bat_Susceptible {
                    self.slaySelfie(selfie)
                }
            }
        }
        
        print("swipe")
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let touchPosition = recognizer.locationInView(self.view)
        
        let afectedFelfies = self.getTouchedSelfies(touchPosition)
        
        if(afectedFelfies.count > 0){
            
            for selfie in afectedFelfies{
                if selfie.selfieType == SelfieTipe.Axe_Susceptible {
                      self.slaySelfie(selfie)
                }
            }
        }
        
        print("long")
    }
    
    @IBAction func throwGranade(sender: AnyObject) {
        let selfieCOntroller = self.storyboard?
            .instantiateViewControllerWithIdentifier("SetSelfieController") as? SetSelfieController
        
        selfieCOntroller?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(selfieCOntroller!, animated: true, completion: nil)
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
        --self.currentSelfieZindex
        self.selfies.insert(selfie)
        self.view.addSubview(selfie)    
        self.animateSelfie(selfie)
        self.changeWeaponImage(selfie)
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
                    delay: 0,
                    options: [UIViewAnimationOptions.AllowUserInteraction,
                        UIViewAnimationOptions.AllowAnimatedContent],
                    animations: {
                        selfieToAnimate.alpha = 1
                        selfieToAnimate.transform = CGAffineTransformMakeScale(5, 5)
                        selfieToAnimate.layer.position.y = CGFloat(screenWidth.size.height + 100)
                        let randmX = CGFloat(arc4random_uniform(UInt32(width + 50)))
                        selfieToAnimate.layer.position.x = randmX - 25
                    },
                    completion: { finish in
                        
                        self.absorbHeart(selfieToAnimate)
                })
        })
    }
    
    func getTouchedSelfies(pointOfTouch: CGPoint) -> [Selfie]{
        
        var touchedSelfies = [Selfie]()
        
        for selfie in self.selfies{
            if (selfie.layer.presentationLayer() != nil) {
                
                if CGRectContainsPoint(selfie.layer.presentationLayer()!.frame	, pointOfTouch){
                    
                    touchedSelfies.append(selfie)
                }
            }
        }
        
        return touchedSelfies
    }
    
    func slaySelfie(selfieToSlay: Selfie){
        
        let isAnimationOk = self.animateSelfieDeath(selfieToSlay)
        
        if isAnimationOk {
        selfieToSlay.removeFromSuperview()
        self.selfies.remove(selfieToSlay)
        ++self.selfiesKilledCount
        self.selfiesKilledLabel.text = String(self.selfiesKilledCount)
        }
    }
    
    func animateSelfieDeath(selfieToAnimate: Selfie) -> Bool{
        
        let sprite = UIImage(named: "selfie-bang-sprite.png")
        let size = CGSize(width: 128, height: 128)
        
        let bombSpriteLayer = SpriteLayerC.init(
            imageAndAnimationSettings: sprite,
            sampleSize: size,
            animationFrameStart: 1,
            animationFrameEnd: 33,
            animationDuration: 2,
            lanimationRepeatCount: 0)
        
        if  selfieToAnimate.layer.presentationLayer() != nil{
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
            
            return true
        }
        
        return false
    }
    
    func absorbHeart(absorbBySelfie: Selfie){
        if(self.selfies.contains(absorbBySelfie as Selfie)){
            self.hearts.takeHeart()
            --self.absorbtionsTillDeath
            
            // TODO: remove selfie and make some signal about that (sound  and animation)
        }
    }
    
    func gameLoop(){
        self.loopHandler = self.utils.setInterval(
            NSTimeInterval(self.currentSelfieReproductionInterval),
            block: { () -> Void in
                
                self.drawSelfie()
                
                if(self.selfiesKilledCount > 0 && self.selfiesKilledCount % 5 == 0){
                    self.loopHandler?.invalidate()
                    self.loopHandler = nil
                    
                    if( self.currentSelfieReproductionInterval > 0.5){
                        
                        self.currentSelfieReproductionInterval -= 0.1
                        
                    }
                    
                    self.gameLoop()
                }
        })
    }
    
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
        
        if self.granadesLeft > 0 {
            for selfie in self.selfies{
                self.slaySelfie(selfie)
            }
            
            --self.granadesLeft
        }
    }
    
    func changeWeaponImage(selfie: Selfie){
        
        let color: UIColor
        let image: UIImage
        
        switch selfie.selfieType!{
        case SelfieTipe.Pike_Susceptible:
            color = UIColor.yellowColor()
            image = UIImage(named: SelfieTipe.Pike_Susceptible.rawValue)!
        case SelfieTipe.Bat_Susceptible:
            color = UIColor.brownColor()
               image = UIImage(named: SelfieTipe.Bat_Susceptible.rawValue)!
        case SelfieTipe.Axe_Susceptible:
            color = UIColor.blackColor()
               image = UIImage(named: SelfieTipe.Axe_Susceptible.rawValue)!
        case SelfieTipe.Nunchaku_Susceptible:
            color = UIColor.grayColor()
               image = UIImage(named: SelfieTipe.Nunchaku_Susceptible.rawValue)!
        }
        
        self.weaponForLastSelfieImageView.image = image
        self.weaponForLastSelfieImageView.layer.borderWidth = 5
        self.weaponForLastSelfieImageView.layer.borderColor = color.CGColor
        
    }
    
    //    func gestureRecognizer(_: UIGestureRecognizer,
    //        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
    //            return true
    //    }
}

