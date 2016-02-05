//
//  SetSelfieController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/5/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class SetSelfieController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var inageView: UIImageView!
    
    
     var imagePicker = UIImagePickerController()
     var selectedSelfiePath: String?
     let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        let path = defaults.stringForKey(DefaultKeys.Selected_Selfie_Path.rawValue)!
        
        let headImage = UIImage(contentsOfFile: path)
        
        inageView.image = headImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSelectedSelfie(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(self.selectedSelfiePath!, forKey: DefaultKeys.Selected_Selfie_Path.rawValue)
        defaults.synchronize()
    }

    @IBAction func selectSelfieFromLibrary(sender: UIButton) {
        
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    @IBAction func selectSelfieFromCamera(sender: UIButton) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
        let localPath = documentDirectory.stringByAppendingPathComponent(imageName!)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImagePNGRepresentation(image)
        
        let writeOK =  data!.writeToFile(localPath, atomically: true)
        
//        if(writeOK){
//            
//            let imageData = NSData(contentsOfFile: localPath)!
//            let photoURL = NSURL(fileURLWithPath: localPath)
//            let imageWithData = UIImage(data: imageData)!
//            
//        }
        
        //let imageData = NSData(contentsOfFile: localPath.absoluteString)!
        let photoURL = NSURL(fileURLWithPath: localPath)
        //let imageWithData = UIImage(data: imageData)!
        
        self.selectedSelfiePath = localPath
        
        let takenFeomPathImage = UIImage(contentsOfFile: localPath)
        
        self.inageView.image = takenFeomPathImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        }
}
