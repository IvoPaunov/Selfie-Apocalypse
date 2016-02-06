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
    
     let defaults = NSUserDefaults.standardUserDefaults()
     var imagePicker = UIImagePickerController()
     let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        setupUmageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSelfieFromLibrary(sender: UIButton) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .PhotoLibrary
        self.imagePicker.modalPresentationStyle = .FullScreen
        presentViewController(self.imagePicker,
            animated: true,
            completion: nil)
//        
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        presentViewController(imagePicker, animated: true, completion: nil)
//        
        
    }
    @IBAction func selectSelfieFromCamera(sender: UIButton) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil {
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.imagePicker.cameraCaptureMode = .Photo
            self.imagePicker.modalPresentationStyle = .FullScreen
            presentViewController(self.imagePicker,
                animated: true,
                completion: nil)
        } else {
            self.missingCameraMessage()
        }
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            
        let imageName = "selfie-" + String(NSDate()) +  imageURL.lastPathComponent!
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
        let imagePath = documentDirectory.stringByAppendingPathComponent(imageName)
        
        let edditedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let resizedImage = utils.ResizeImage(edditedImage, targetSize: CGSizeMake(250.0, 250.0))            
            
        let data = UIImagePNGRepresentation(resizedImage)
        
        let writeOK =  data!.writeToFile(imagePath, atomically: true)
            
        // TODO: Add some error handling if write is not OK!
            
        let takenFeomPathImage = UIImage(contentsOfFile: imagePath)
        
        self.inageView.image = takenFeomPathImage
        self.setCitcularImageView()
            
        self.saveSelectedImagePath(imagePath)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        }
    
    func saveSelectedImagePath(imagePath: String){
        self.defaults.setValue(imagePath, forKey: DefaultKeys.Selected_Selfie_Path.rawValue)
        self.defaults.synchronize()
    }
    
    func missingCameraMessage(){
        let alertVC = UIAlertController(
            title: "No Selfie Camera",
            message: "Ooops, you device has no selfie camera. Choose from library, wisely!",
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func setupUmageView(){

        
        var currentSelfie: UIImage?
        let path = defaults.stringForKey(DefaultKeys.Selected_Selfie_Path.rawValue)        
        
        if path != nil{
            let selfieImage = UIImage(contentsOfFile: path!)
            currentSelfie = selfieImage
        }
        
        if(currentSelfie != nil){
            self.inageView.image = currentSelfie!
        }
        else{
            let defaultImage = UIImage(named: "Selfie")
            
            self.inageView.image =   defaultImage
        }
        
        self.setCitcularImageView()
    }
    
    func setCitcularImageView(){
        self.inageView.contentMode = .ScaleAspectFit
        self.inageView.layer.cornerRadius = self.inageView.layer.frame.height / 2
        self.inageView.clipsToBounds = true;
        self.inageView.layer.borderWidth = 3
        self.inageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
}
