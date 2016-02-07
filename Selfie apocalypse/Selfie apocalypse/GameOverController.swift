//
//  GameOverController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/6/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverController: UIViewController {
    
    var score: Int?
    var selfOverAudioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var labelScore: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage()
        self.handleScore()
        self.setupAudioPlayers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.removeAudioPlayers()
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
                self.updateHighscoreInParse(self.score!)
            }
        }
    }
    
    func updateHighscoreInParse(score: Int){
        let parseService = ParseService()
        parseService.addOrUpdeteSlayerInfo(nil, supremeScore: score)
    }
    
    func setBackgroundImage(){
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "SelfOver")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func setupAudioPlayers(){
        
        if let selfOverAudioUrl = NSBundle.mainBundle().URLForResource("self-over",
            withExtension: "mp3") {
                self.selfOverAudioPlayer = AVAudioPlayerPool.playerWithURL(selfOverAudioUrl)
                self.selfOverAudioPlayer?.prepareToPlay()
                self.selfOverAudioPlayer?.volume = 0.3
                self.selfOverAudioPlayer?.numberOfLoops = 99
                self.selfOverAudioPlayer?.play()
        }
    }
    
    func selfieDidMadeSelfie(selfie: Selfie){
        
    }
    
    func removeAudioPlayers(){
        
        if ((self.selfOverAudioPlayer) != nil) {
            self.selfOverAudioPlayer?.currentTime = 0
            self.selfOverAudioPlayer?.stop()
            self.selfOverAudioPlayer = nil
        }
    }
}
