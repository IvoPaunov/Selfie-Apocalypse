//
//  LivesStatusBar.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

@IBDesignable class LivesStatusBar: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    @IBOutlet weak var thirdHeart: UIImageView!
    @IBOutlet weak var secondHeart: UIImageView!
    @IBOutlet weak var firstHeart: UIImageView!
    
    var view:UIView!;
    
    var heartsCount: Int;
    
    var heartsSpriteLayer: SpriteLayerC?;
    
    override init(frame: CGRect) {
        heartsCount = 3
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        heartsCount = 3
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LivesStatusBar", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        
        self.addSubview(view);
    }
    
    func takeHeart(){
        if self.heartsSpriteLayer == nil{
            self.initHeartSpriteLayer()
        }
        
        let x: CGFloat;
        let y: CGFloat;
        
        switch(heartsCount){
        case 3:
            x = firstHeart.frame.origin.x
            y = firstHeart.frame.origin.y
            self.fadeHeart(firstHeart)
        case 2:
            x = secondHeart.frame.origin.x
            y = secondHeart.frame.origin.y
            self.fadeHeart(secondHeart)
        case 1:
            x = thirdHeart.frame.origin.x
            y = thirdHeart.frame.origin.y
            self.fadeHeart(thirdHeart)
        default:
            //self.noBombsLabel.text = "Out of granades!"
            self.heartsSpriteLayer?.removeAllAnimations()
            self.heartsSpriteLayer?.removeFromSuperlayer()
            return
        }
        
        --self.heartsCount
        
        self.heartsSpriteLayer?.frame = CGRect(x: x, y: y, width: 30, height:30)
        
        self.heartsSpriteLayer?.removeAllAnimations()
        
        self.heartsSpriteLayer?.playAnimationAgain()
    }
    
    private func fadeHeart(imageToFade: UIImageView){
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            imageToFade.alpha = 0.0
            
            }, completion: nil)
    }
    
    private func initHeartSpriteLayer(){
        
        let sprite = UIImage(named: "hearts-sprite.png")
        let size = CGSize(width: 128, height: 128)
        
        self.heartsSpriteLayer = SpriteLayerC.init(
            andAnimationSettings: sprite,
            sampleSize: size,
            animationFrameStart: 1,
            animationFrameEnd: 51,
            animationDuration: 2,
            lanimationRepeatCount: 0)
        
        self.layer.addSublayer(self.heartsSpriteLayer!)
    }
}
