//
//  ViewController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import AVFoundation
import UIKit
import Foundation

class GameController: UIViewController, UIGestureRecognizerDelegate, AVAudioPlayerDelegate {
    var utils = Utils()
    
    var currentSelfieZindex = 10000000
    var selfiesKilledCount = 0
    var absorbtionsTillDeath = 3
    var granadesLeft = 3
    var currentSelfiesWaveSpeed = 15
    var currentSelfieReproductionInterval: Float = 3
    var selfies = Set<Selfie>()
    var loopHandler: NSTimer?
    var isGameFinished = false
    
    var backGroundAudioPlayer: AVAudioPlayer?
    var selfieAudioPlayer: AVAudioPlayer?
    var batAudioPlayer: AVAudioPlayer?
    var axeAudioPlayer: AVAudioPlayer?
    var pikeAudioPlayer: AVAudioPlayer?
    var nunchakuAudioPlayer: AVAudioPlayer?
    var cameraAudioPlayer: AVAudioPlayer?
    var granadeAudioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var weaponForLastSelfieImageView: UIImageView!
    
    @IBOutlet weak var selfiesKilledLabel: UILabel!
    
    @IBOutlet weak var granades: GranadesStatusBar!
    
    @IBOutlet weak var hearts: LivesStatusBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestures()
        // TODO: Add countdown
        self.setBackgroundImage()
        self.loopHandler?.invalidate()
        self.loopHandler = nil
        self.gameLoop()
        self.setupAudioPlayers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.removeAudioPlayers()
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
                    self.pikeAudioPlayer?.stop()
                    self.pikeAudioPlayer?.currentTime = 0
                    self.pikeAudioPlayer?.play()
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
                        self.batAudioPlayer?.stop()
                        self.nunchakuAudioPlayer?.currentTime = 0
                        self.nunchakuAudioPlayer?.play()
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
                    self.batAudioPlayer?.stop()
                    self.batAudioPlayer?.currentTime = 0
                    self.batAudioPlayer?.play()
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
                    self.axeAudioPlayer?.stop()
                    self.axeAudioPlayer?.currentTime = 0;
                    self.axeAudioPlayer?.play()
                }
            }
        }
        
        print("long")
    }
    
    func  drawSelfie(){
        
        if self.isGameFinished {
            return
        }
        
        let selfie = Selfie()
        let randomX = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width  - 100) + 50))
        let randomY = CGFloat(arc4random_uniform(20) + 30)
        
        let frame = CGRectMake(randomX, randomY, randomY, randomY)
        selfie.frame = frame
        selfie.backgroundColor = UIColor.clearColor()

        selfie.layer.zPosition = CGFloat(self.currentSelfieZindex)
        self.currentSelfieZindex -= 1
        selfie.alpha = 0
        selfie.userInteractionEnabled = true
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
                        let randmX = CGFloat(arc4random_uniform(UInt32(width + 30)))
                        selfieToAnimate.layer.position.x = randmX - 15
                    },
                    completion: { finish in
                        
                        if self.isGameFinished {
                            return
                        }
                        
                        if self.absorbtionsTillDeath  >= 0{
                            
                            self.absorbHeart(selfieToAnimate)
                        }
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
            
            if !self.isGameFinished {
                ++self.selfiesKilledCount
                self.selfiesKilledLabel.text = String(self.selfiesKilledCount)
            }
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
            let currentSelfiePosition = ((selfieToAnimate.layer.presentationLayer()!) as! CALayer).position
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
            
            self.selfies.remove(absorbBySelfie)
            absorbBySelfie.layer.removeAllAnimations()
            absorbBySelfie.removeFromSuperview()
            self.cameraAudioPlayer?.play()
            self.screenSelfieFlashAnimation()
            
            
            if(self.absorbtionsTillDeath == 0){
                
                self.absorbtionsTillDeath--
                self.loopHandler?.invalidate()
                self.loopHandler = nil
                
                self.isGameFinished = true
                self.handleGameOver()
            }
        }
    }
    
    func gameLoop(){
        
        if self.isGameFinished {
            self.loopHandler?.invalidate()
            self.loopHandler = nil
            return
        }
        
        self.loopHandler = self.utils.setInterval(
            NSTimeInterval(self.currentSelfieReproductionInterval),
            block: { () -> Void in
                
                if self.isGameFinished {
                    self.loopHandler?.invalidate()
                    self.loopHandler = nil
                    return
                }
                
                self.drawSelfie()
                
                if(self.selfiesKilledCount > 0 && self.selfiesKilledCount % 7 == 0){
                    self.loopHandler?.invalidate()
                    self.loopHandler = nil
                    
                    if( self.currentSelfieReproductionInterval > 0.7){
                        
                        self.currentSelfieReproductionInterval -= 0.07
                        
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
        
        
        self.setBaskgroundAudio()
        
        if self.granadesLeft > 0 {
            self.granadeAudioPlayer?.play()
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
    
    func setBackgroundImage(){
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "Background")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func handleGameOver(){
        
        self.loopHandler?.invalidate()
        self.loopHandler = nil
//        for selfie in self.selfies{
//            self.slaySelfie(selfie)
//        }
        
        let gameOverController = self.storyboard?
            .instantiateViewControllerWithIdentifier("GameOverController") as? GameOverController
        gameOverController?.score = self.selfiesKilledCount
        
        self.utils.setTimeout(3, block: { () ->  Void in
            
            self.view.layer.removeAllAnimations()
            
            gameOverController?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(gameOverController!, animated: true, completion: nil)
        })
    }
    
    func setupAudioPlayers(){
        
        self.setBaskgroundAudio()
        
        if let batAudioUrl = NSBundle.mainBundle().URLForResource("bat",
            withExtension: "mp3") {
                self.batAudioPlayer = AVAudioPlayerPool.playerWithURL(batAudioUrl)
                self.batAudioPlayer?.prepareToPlay()
                self.batAudioPlayer?.volume = 0.7
                self.batAudioPlayer?.numberOfLoops = 0
        }
        
        if let axeAudioUrl = NSBundle.mainBundle().URLForResource("axe",
            withExtension: "mp3") {
                self.axeAudioPlayer = AVAudioPlayerPool.playerWithURL(axeAudioUrl)
                self.axeAudioPlayer?.prepareToPlay()
                self.axeAudioPlayer?.volume = 0.9
                self.axeAudioPlayer?.numberOfLoops = 0
        }
        
        if let pikeAudioUrl = NSBundle.mainBundle().URLForResource("pike",
            withExtension: "mp3") {
                self.pikeAudioPlayer = AVAudioPlayerPool.playerWithURL(pikeAudioUrl)
                self.pikeAudioPlayer?.prepareToPlay()
                self.pikeAudioPlayer?.volume = 0.7
                self.pikeAudioPlayer?.numberOfLoops = 0
        }
        
        if let nunAudioUrl = NSBundle.mainBundle().URLForResource("nun",
            withExtension: "mp3") {
                self.nunchakuAudioPlayer = AVAudioPlayerPool.playerWithURL(nunAudioUrl)
                self.nunchakuAudioPlayer?.prepareToPlay()
                self.nunchakuAudioPlayer?.volume = 0.7
                self.nunchakuAudioPlayer?.numberOfLoops = 0
        }
        
        if let cameraAudioUrl = NSBundle.mainBundle().URLForResource("camera",
            withExtension: "mp3") {
                self.cameraAudioPlayer = AVAudioPlayerPool.playerWithURL(cameraAudioUrl)
                self.cameraAudioPlayer?.prepareToPlay()
                self.cameraAudioPlayer?.volume = 1
                self.cameraAudioPlayer?.numberOfLoops = 0
        }
        
        if let granageAudioUrl = NSBundle.mainBundle().URLForResource("boom",
            withExtension: "mp3") {
                self.granadeAudioPlayer = AVAudioPlayerPool.playerWithURL(granageAudioUrl)
                self.granadeAudioPlayer?.prepareToPlay()
                self.granadeAudioPlayer?.volume = 1
                self.granadeAudioPlayer?.numberOfLoops = 0
        }
    }
    
    func selfieDidMadeSelfie(selfie: Selfie){
        
    }
    
    func removeAudioPlayers(){
        
        if ((self.backGroundAudioPlayer) != nil) {
            self.backGroundAudioPlayer?.stop()
            self.backGroundAudioPlayer = nil
        }
        
        if ((self.batAudioPlayer) != nil) {
            self.batAudioPlayer?.stop()
            self.batAudioPlayer = nil
        }
        
        if ((self.axeAudioPlayer) != nil) {
            self.axeAudioPlayer?.stop()
            self.axeAudioPlayer = nil
        }
        
        if ((self.pikeAudioPlayer) != nil) {
            self.pikeAudioPlayer?.stop()
            self.pikeAudioPlayer = nil
        }
        
        if ((self.nunchakuAudioPlayer) != nil) {
            self.nunchakuAudioPlayer?.stop()
            self.nunchakuAudioPlayer = nil
        }
        
        if ((self.cameraAudioPlayer) != nil) {
            self.cameraAudioPlayer?.stop()
            self.cameraAudioPlayer = nil
        }
        
        if ((self.granadeAudioPlayer) != nil) {
            self.granadeAudioPlayer?.stop()
            self.granadeAudioPlayer = nil
        }
    }
    
    func setBaskgroundAudio(){
        self.backGroundAudioPlayer?.stop()
        self.backGroundAudioPlayer = nil
        
        let randomNumber = arc4random_uniform(UInt32(5)) + 1
        
        let baskgroundAudio = "background-\(randomNumber)"
        
        if let backgraundAudioUrl = NSBundle.mainBundle().URLForResource(baskgroundAudio,
            withExtension: "mp3") {
                self.backGroundAudioPlayer = AVAudioPlayerPool.playerWithURL(backgraundAudioUrl)
                self.backGroundAudioPlayer?.prepareToPlay()
                self.backGroundAudioPlayer?.volume = 0.3
                self.backGroundAudioPlayer?.numberOfLoops = 0
                self.backGroundAudioPlayer?.delegate = self
                self.backGroundAudioPlayer?.play()
        }
    }
    
    func screenSelfieFlashAnimation() {
        
        let flashView = UIView(frame: self.view.frame)
        flashView.backgroundColor = UIColor.whiteColor()
        flashView.layer.zPosition = CGFloat(HUGE) + CGFloat(1.0)
        self.view.addSubview(flashView)
        
        UIView.animateWithDuration(1.3, delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                
                flashView.alpha = 0.0
                
            }, completion: { (done) -> Void in
                
                flashView.removeFromSuperview()
        })
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        player.stop()
        //player.
        
        self.setBaskgroundAudio()
    } 
}

