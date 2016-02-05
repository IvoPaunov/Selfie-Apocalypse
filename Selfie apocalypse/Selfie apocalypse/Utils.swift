//
//  Utils.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/5/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import Foundation

public class  Utils {
    
     func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: "main", userInfo: nil, repeats: false)
    }
    
     func setInterval(interval:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(interval, target: NSBlockOperation(block: block), selector: "main", userInfo: nil, repeats: true)
    }
}