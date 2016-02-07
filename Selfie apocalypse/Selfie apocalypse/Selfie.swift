//
//  Selfie.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/4/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit


enum SelfieTipe: String {
    
    case Pike_Susceptible = "Pike"
    case Bat_Susceptible = "Bat"
    case Axe_Susceptible = "Axe"
    case Nunchaku_Susceptible = "Nunchaku"
    
    static var allTypes: [SelfieTipe] = [.Pike_Susceptible, .Bat_Susceptible, .Nunchaku_Susceptible, .Axe_Susceptible]
    
    static func randomType() -> SelfieTipe {
        let i = Int(arc4random_uniform(UInt32(SelfieTipe.allTypes.count)))
        
        return allTypes[i]
    }
}

class Selfie: UIView {
    
    var selfieType: SelfieTipe?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func drawRect(rect: CGRect) {
        var path = defaults.stringForKey(DefaultKeys.Selected_Selfie_Path.rawValue)
        
        if path == nil{
            path = ""
        }
        
        var headImage = UIImage(contentsOfFile: path!)
        
        if headImage == nil {
            headImage = UIImage(named: "Selfie")
        }
        
        let selfieHead = UIImageView(
            frame: CGRectMake(
                rect.origin.x,
                rect.origin.y,
                rect.size.width,
                rect.size.height))
        
        selfieHead.userInteractionEnabled = true
        selfieHead.image = headImage
        selfieHead.layer.cornerRadius = selfieHead.bounds.size.width / 2
        selfieHead.layer.masksToBounds = true
        
        
        var spriteColor: String?

        if self.selfieType != nil{
            
            selfieHead.layer.borderWidth = 1
            let color: UIColor
            
            switch self.selfieType!{
            case SelfieTipe.Pike_Susceptible:
                color = UIColor.yellowColor()
                spriteColor = "yellow"
            case SelfieTipe.Bat_Susceptible:
                color = UIColor.brownColor()
                spriteColor = "brown"
            case SelfieTipe.Axe_Susceptible:
                color = UIColor.blackColor()
                spriteColor = "black"
            case SelfieTipe.Nunchaku_Susceptible:
                color = UIColor.grayColor()
                spriteColor = "gray"
            }
            
            selfieHead.layer.borderColor = color.CGColor
        }
        
        self.userInteractionEnabled = true
        
        let torsoSprite = self.initTorsoSpriteLayer(spriteColor!)
        
        let x = CGFloat( 0) //selfieHead.layer.position.x / 2
        let y = (selfieHead.layer.position.y + selfieHead.frame.size.height ) / 1.75
        let width = selfieHead.frame.size.width
        let height = width
        
        torsoSprite.frame = CGRect(x: x, y: y, width: width, height:height)
        
        torsoSprite.playAnimationAgain()
        torsoSprite.zPosition = selfieHead.layer.zPosition - 1
        
        self.addSubview(selfieHead)
        self.layer.addSublayer(torsoSprite)
    }
    
    
    private func initTorsoSpriteLayer(color: String) -> SpriteLayerC{
        
        
        
        
        let sprite = UIImage(named: "selfie-torso-sprite-\(color).png")
        let size = CGSize(width: 125, height: 110)
        
        let torsoSpriteLayer = SpriteLayerC.init(
            imageAndAnimationSettings: sprite,
            sampleSize: size,
            animationFrameStart: 1,
            animationFrameEnd: 177,
            animationDuration: 5,
            lanimationRepeatCount: 20)
        
        return torsoSpriteLayer
    }
    
    private func setSelfType(){
        self.selfieType = SelfieTipe.randomType()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSelfType()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setSelfType()
    }
}
