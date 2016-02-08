//
//  TheTrueStoryViewController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/8/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class TheTrueStoryViewController: UIViewController {
    
    let transitionManager = TransitionManager()
    
    @IBOutlet weak var theTrueStoryLabe: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheTrueStory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTheTrueStory(){
        let path = NSBundle.mainBundle().pathForResource("the-true-story", ofType: "txt")
        
        var text: String?
        
        do{
            text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        }
        catch{            
            text = "There is no stroy someting wrnog happend when reading the file."
        }
        
        self.theTrueStoryLabe.text = text
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        self.transitionManager.toLeft = false
        
        toViewController.transitioningDelegate = self.transitionManager
    }
}
