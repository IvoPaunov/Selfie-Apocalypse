//
//  SelfieSlayingSchoolController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/7/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class SelfieSlayingSchoolController: UIViewController, UITableViewDataSource {
    
    let transitionManager = TransitionManager()
    
    var weapons = [SelfieSalyingWeaponDescription]()
    let weaponCellIdentifier = "WeaponCell"
    
    @IBOutlet weak var weaponsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWeaponsTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setWeaponDescriptions()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setWeaponDescriptions()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.weapons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.getWeaponCell(indexPath)
        return cell
    }
    
    func getWeaponCell(indexPath: NSIndexPath) -> HowToSlayCell{
        
        let weapon = self.weapons[indexPath.row]
        
        let cell = NSBundle.mainBundle().loadNibNamed("HowToSlayCell", owner: nil, options: nil)[0] as! HowToSlayCell
        
        cell.weaponImageViwe.image = weapon.image
        cell.weaponImageViwe.layer.borderColor = weapon.borderColor
        cell.weaponImageViwe.layer.borderWidth = 4
        cell.weaponTitleLabel.text = weapon.title
        cell.weaponDescriptionLabel.text = weapon.description
        
        return cell
    }
    
    func setWeaponDescriptions(){
        
        let granadeWeapon = SelfieSalyingWeaponDescription()
        granadeWeapon.image = UIImage(named: "Granade")
        granadeWeapon.borderColor = UIColor.clearColor().CGColor
        granadeWeapon.title = "Granade"
        granadeWeapon.description = "This is very powerfull weapon that can slay all selfies in the field.\n" +
            "The problem is that you have only 3 of them.\n " +
        "* To use one just shake tour device.\n(That also will change the music.)"
        
        let pikeWeapon = SelfieSalyingWeaponDescription()
        pikeWeapon.image = UIImage(named: "Pike")
        pikeWeapon.borderColor = UIColor.yellowColor().CGColor
        pikeWeapon.title = "Pike"
        pikeWeapon.description = "The pike can slay only selfies with yellow tint.\n" +
        "* To the pike some selfie you should double tap on it"
        
        let axeWeapon = SelfieSalyingWeaponDescription()
        axeWeapon.image = UIImage(named: "Axe")
        axeWeapon.borderColor = UIColor.blackColor().CGColor
        axeWeapon.title = "Axe"
        axeWeapon.description = "The axe can slay only selfies with black tint.\n" +
        "* The axe is very heavy so to use it you have to long press the selfie you want to slay"
        
        let batWeapon = SelfieSalyingWeaponDescription()
        batWeapon.image = UIImage(named: "Bat")
        batWeapon.borderColor = UIColor.brownColor().CGColor
        batWeapon.title = "The baseball bat"
        batWeapon.description = "This classic selfie slaying weapon is very powerfull but can only slay selfies with brown tint.\n" +
        "* This is very easy to use weapon - just swipe lefto or right over the selfie and it will be slayed"
        
        let nunchakuWeapon = SelfieSalyingWeaponDescription()
        nunchakuWeapon.image = UIImage(named: "Nunchaku")
        nunchakuWeapon.borderColor = UIColor.grayColor().CGColor
        nunchakuWeapon.title = "Nunchaku"
        nunchakuWeapon.description = "In every selfie apocalypse situation thera are some hard moments.\n" +
            "This is the weapon for the most powerfull gray tint selfies.\n" +
        "* You have to pinch out with 2 fingers over the selfie"
        
        self.weapons.append(granadeWeapon)
        self.weapons.append(pikeWeapon)
        self.weapons.append(axeWeapon)
        self.weapons.append(batWeapon)
        self.weapons.append(nunchakuWeapon)
    }
    
    func setupWeaponsTable(){
        weaponsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: weaponCellIdentifier)
        weaponsTable.rowHeight = UITableViewAutomaticDimension
        weaponsTable.estimatedRowHeight = 220
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        self.transitionManager.toLeft = false
        
        toViewController.transitioningDelegate = self.transitionManager
    }
}
