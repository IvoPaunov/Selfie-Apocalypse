//
//  ViewController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController {
    
    var currentSelfieZindex = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
        let frame = CGRectMake(100, 100, 50, 50)
        selfie.frame = frame
        selfie.backgroundColor = UIColor.clearColor()
        selfie.layer.zPosition = CGFloat(currentSelfieZindex)
//        selfie.layer.cornerRadius = selfie.bounds.size.width / 2
//        selfie.layer.masksToBounds = true
        currentSelfieZindex--
        self.view.addSubview(selfie)
        
        animateSelfie(selfie)
    }
    
    func animateSelfie(selfieToAnimate: UIView){
        
        GLKView.animateWithDuration(5,
            animations: {
                selfieToAnimate.transform = CGAffineTransformMakeScale(5, 5)
                selfieToAnimate.layer.position.y = 400
                selfieToAnimate.layer.position.x = 400
            },
            completion: { finish in
                
                UIView.animateWithDuration(0.6){
                    selfieToAnimate.transform = CGAffineTransformIdentity
                    selfieToAnimate.removeFromSuperview()
                      self.hearts.takeHeart()
                }
        })
        
    }
    
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: "main", userInfo: nil, repeats: false)
    }
}

