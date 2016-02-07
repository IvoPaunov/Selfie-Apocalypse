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
        
        if self.selfieType != nil{
            
            selfieHead.layer.borderWidth = 2
            let color: UIColor
            
            switch self.selfieType!{
            case SelfieTipe.Pike_Susceptible: color = UIColor.yellowColor()
            case SelfieTipe.Bat_Susceptible: color = UIColor.brownColor()
            case SelfieTipe.Axe_Susceptible: color = UIColor.blackColor()
            case SelfieTipe.Nunchaku_Susceptible: color = UIColor.grayColor()
            }
            
            selfieHead.layer.borderColor = color.CGColor
        }
        
        self.userInteractionEnabled = true
        
        self.addSubview(selfieHead)
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
