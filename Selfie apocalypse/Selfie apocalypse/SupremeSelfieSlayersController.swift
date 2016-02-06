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

    var supremeSlayers: [PFObject]?
    
    @IBOutlet weak var tableViewSupremeSlayers: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSupremeSlayers.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        self.getSupremeSayers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return (self.supremeSlayers?.count)!
    }
    
       func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = (self.supremeSlayers![indexPath.row] as? Slayer)!.slayerName
        
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
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (result, error) -> Void in
            if(error == nil){
                self.supremeSlayers = result
                print(result)
                self.tableViewSupremeSlayers.reloadData()
                
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
