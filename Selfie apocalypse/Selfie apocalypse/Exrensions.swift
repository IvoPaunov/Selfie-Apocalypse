//
//  Exrensions.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/7/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import Foundation

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}