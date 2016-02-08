//
//  ParseService.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/6/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import Parse

class ParseService {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func getSupremeSlayer(count: Int) -> [PFObject] {
        let query = PFQuery(className: String(Slayer))
        query.cachePolicy = .NetworkElseCache
        query.orderByDescending("supremeScore")
        query.limit = count
        
        query.findObjectsInBackgroundWithBlock {
            (result, error) -> Void in
            if(error == nil){
                print(result)
            }
        }
        
        let res = [PFObject]()
        
        return res
    }
    
    func addOrUpdeteSlayerInfo(newSlayerName: String?, supremeScore: Int?){
        
        let query = PFQuery(className: String(Slayer))
        query.cachePolicy = .NetworkElseCache
        
        var currentSlayerName: String?
        
        if newSlayerName == nil {
            currentSlayerName = defaults.stringForKey(DefaultKeys.Slayer_Name.rawValue)
            
            if currentSlayerName == nil {
                currentSlayerName = "Slayer-" + NSUUID().UUIDString
            }
        }
        else {
            currentSlayerName = newSlayerName
        }
        
        var currentSlayer: Slayer?
        
        let slayerParseId = defaults.stringForKey(DefaultKeys.Slayer_Parse_Id.rawValue)
        
        if(slayerParseId != nil){
            
            query.getObjectInBackgroundWithId(slayerParseId!) {
                (slayer: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else {
                    
                  let rsultSlayer = slayer as! Slayer
                    
                    rsultSlayer.slayerName = currentSlayerName!
                    
                    if  supremeScore != nil {
                        rsultSlayer.supremeScore = supremeScore!
                    }
          
                    rsultSlayer.saveInBackground()
                    
                    print(slayer)
                }
            }
        } else {
            currentSlayer = Slayer()
            currentSlayer?.identityId = UIDevice.currentDevice().identifierForVendor!.UUIDString
            currentSlayer?.slayerName = currentSlayerName!
            
            if  supremeScore != nil {
                currentSlayer?.supremeScore = supremeScore!
            }
            
            currentSlayer?.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if (success == true) {
                    let parseId = currentSlayer?.objectId
                    self.defaults.setValue(parseId, forKey: DefaultKeys.Slayer_Parse_Id.rawValue)
                } else {
                    print(error)
                }
            }
        }
    }
}
