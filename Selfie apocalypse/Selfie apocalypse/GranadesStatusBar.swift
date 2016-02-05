//
//  GranadesStatusBar.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

@IBDesignable class GranadesStatusBar: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    @IBOutlet weak var noBombsLabel: UILabel!
    
    @IBOutlet weak var thirdGranade: UIImageView!
    
    @IBOutlet weak var secondGranade: UIImageView!
    
    @IBOutlet weak var firstGranade: UIImageView!
    
    var view:UIView!;
    
    var granadesCount: Int;
    
    var bombSpriteLayer: SpriteLayerC?;
    
    override init(frame: CGRect) {
        self.granadesCount = 3
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.granadesCount = 3
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "GranadesStatusBar", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        self.addSubview(view);
    }
    
    func throwGranade(){
        if self.bombSpriteLayer == nil{
            self.initBombSpriteLayer()
        }
        
        let x: CGFloat;
        let y: CGFloat;
        
        switch(granadesCount){
        case 3:
            x = firstGranade.frame.origin.x
            y = firstGranade.frame.origin.y
            self.fadeGranade(firstGranade)
        case 2:
            x = secondGranade.frame.origin.x
            y = secondGranade.frame.origin.y
            self.fadeGranade(secondGranade)
        case 1:
            x = thirdGranade.frame.origin.x
            y = thirdGranade.frame.origin.y
            self.fadeGranade(thirdGranade)
        default:
            self.noBombsLabel.text = "Out of granades!"
            self.bombSpriteLayer?.removeAllAnimations()
            self.bombSpriteLayer?.removeFromSuperlayer()
            return
        }
        
        --self.granadesCount
        
        self.bombSpriteLayer?.frame = CGRect(x: x, y: y, width: 30, height:30)
        
        self.bombSpriteLayer?.removeAllAnimations()
        
        self.bombSpriteLayer?.playAnimationAgain()
    }
    
    private func fadeGranade(imageToFade: UIImageView){
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            imageToFade.alpha = 0.0
            
            }, completion: nil)
    }
    
    private func initBombSpriteLayer(){
        
        let sprite = UIImage(named: "bang-sprite.png")
        let size = CGSize(width: 100, height: 100)
        
        self.bombSpriteLayer = SpriteLayerC.init(
            imageAndAnimationSettings: sprite,
            sampleSize: size,
            animationFrameStart: 1,
            animationFrameEnd: 82,
            animationDuration: 2,
            lanimationRepeatCount: 0)
        
        self.layer.addSublayer(self.bombSpriteLayer!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
}
