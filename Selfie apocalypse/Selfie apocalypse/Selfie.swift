//
//  Selfie.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/4/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class Selfie: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func drawRect(rect: CGRect) {
        
        let headImage = UIImage(named: "Selfie")
        
        let selfieHead = UIImageView(frame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height))
        
        selfieHead.image = headImage
        selfieHead.layer.cornerRadius = selfieHead.bounds.size.width / 2
        selfieHead.layer.masksToBounds = true
        
        self.addSubview(selfieHead)
        // Drawing code
    }

}
