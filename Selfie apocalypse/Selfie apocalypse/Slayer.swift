//
//  Slayer.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/6/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import Parse

class Slayer : PFObject, PFSubclassing {
    
    @NSManaged var identityId: String
    
    @NSManaged var slayerName: String
    
    @NSManaged var supremeScore: Int    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Slayer"
    }
}