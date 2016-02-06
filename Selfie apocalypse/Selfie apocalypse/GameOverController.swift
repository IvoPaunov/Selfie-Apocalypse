//
//  GameOverController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/6/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class GameOverController: UIViewController {
    
    var score: Int?
    
    @IBOutlet weak var labelText: UILabel!
    
    
    @IBOutlet weak var labelScore: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleScore()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleScore(){
        if self.score != nil {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let slayerSupremeScore = defaults.valueForKey(DefaultKeys.Player_Top_Score.rawValue) as? Int
            
            
            let currentScore = self.score!
            
                if  slayerSupremeScore != nil && slayerSupremeScore! > currentScore{
                    
                    self.labelText.text = "Nice but not your supreme!"
                    self.labelScore.text = "\(currentScore)"
                }
                else{	
                    self.labelText.text = "WOW this is youe supreme score!"
                    self.labelScore.text = "\(currentScore)"
                    
                    defaults.setValue(self.score, forKey: DefaultKeys.Player_Top_Score.rawValue)
                    defaults.synchronize()
                }
            
        }
    }
}
