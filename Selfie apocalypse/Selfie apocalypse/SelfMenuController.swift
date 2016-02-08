//
//  SelfMenuController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/8/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class SelfMenuController: UIViewController {

    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController        
        
             toViewController.transitioningDelegate = self.transitionManager
    }
}
