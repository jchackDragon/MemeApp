//
//  ViewController.swift
//  MemeApp
//
//  Created by Juan Carlos Lopez on 10/21/16.
//  Copyright © 2016 Juan Carlos Lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFielBotton: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName:UIColor.black,
        NSForegroundColorAttributeName:UIColor.white,
        NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size:40)!,
        NSStrokeWidthAttributeName:-3.0
    ] as [String:Any]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textFieldTop.text = "TOP"
        self.textFielBotton.text = "BOTTOM"
        
        //Set the Text style to the textfields
        self.textFieldTop.defaultTextAttributes = memeTextAttributes
        self.textFielBotton.defaultTextAttributes = memeTextAttributes
        
        //Align the text to center
        self.textFieldTop.textAlignment = .center
        self.textFielBotton.textAlignment = .center
        
        //Add the class delegate to textField
        self.textFieldTop.delegate = self
        self.textFielBotton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Checkk if the camara sourceType is avalible
        self.camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera
        )
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                  target: self,
                                                                  action: #selector(shareMeme))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                action: #selector(self.dismissViewController))
        
        self.navigationItem.leftBarButtonItem?.isEnabled =  (self.imagePickerView.image != nil)
        
            
        self.navbar.items = [self.navigationItem]
                
    }

    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
       
    }
    
    @IBAction func pickImageFromCamara(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image =  info["UIImagePickerControllerOriginalImage"] as? UIImage{
            //Set the image view with the image picked in the Image Library
            self.imagePickerView.image = image
            
            self.imagePickerView.contentMode = .scaleAspectFill
            //Dismis the controller after chosen the image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func save(){
        //Meme image 
        let memeImage = generateMemedImage()
        // Create the meme
        let meme = Meme(topText: textFieldTop.text!, bottom: textFielBotton.text!,
                        image: imagePickerView.image, memeImage: memeImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage{
        // TODO: Hide toolbar and navbar
        toolbar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        //Render view from to an Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        //Get the image created fron the hierarchy view
        let memeImage: UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        //End the graphics image context
        UIGraphicsEndImageContext()
        
        
        // TODO: Show the toolbar and navbar
        toolbar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        return memeImage
    }

    func shareMeme(){
        let image = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {
            (activityType, complete, returnedItems, activityError ) in
            
            if complete {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(shareController, animated: true, completion: nil)
        
        
    }
    
    func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }

}

