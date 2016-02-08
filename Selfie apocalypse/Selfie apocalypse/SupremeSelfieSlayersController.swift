//
//  TopSelfieSlayersController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/6/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit
import Parse

class SupremeSelfieSlayersController: UIViewController, UITableViewDataSource {
    
    let transitionManager = TransitionManager()

    var supremeSlayers: [PFObject]?
    let supremeSlayerCellIdentifier = "SupremeSlayerCell"
    
    @IBOutlet weak var tableViewSupremeSlayers: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getSupremeSayers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.supremeSlayers?.count)!
    }
    
       func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.getSupremeSlayerCell(indexPath)
        
        return cell
    }
    
    func getSupremeSlayerCell(indexPath: NSIndexPath) -> SupremeSlayerCell{
        let cell = NSBundle.mainBundle()
            .loadNibNamed(self.supremeSlayerCellIdentifier,
                owner: nil,
                options: nil)[0] as! SupremeSlayerCell
        
        cell.scoreLabel!.text = String((self.supremeSlayers![indexPath.row] as? Slayer)!.supremeScore)
        
        cell.nameLabel!.text = (self.supremeSlayers![indexPath.row] as? Slayer)!.slayerName
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.supremeSlayers = [Slayer]()
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.supremeSlayers = [Slayer]()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func getSupremeSayers(){
        let query = PFQuery(className: String(Slayer))
        query.cachePolicy = .NetworkElseCache
        query.orderByDescending("supremeScore")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock {
            (result, error) -> Void in
            if(error == nil){
                self.supremeSlayers = result
                print(result)
                self.tableViewSupremeSlayers.reloadData()
                
            }
        }
    }
    
    func setupSupremeSlayersTable(){
        tableViewSupremeSlayers
            .registerClass(UITableViewCell.self, forCellReuseIdentifier: self.supremeSlayerCellIdentifier)
        tableViewSupremeSlayers.rowHeight = UITableViewAutomaticDimension
        tableViewSupremeSlayers.estimatedRowHeight = 56
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        self.transitionManager.toLeft = false
        
        toViewController.transitioningDelegate = self.transitionManager
    }
}
