//
//  RegisterViewController.swift
//  HmiRegistration
//
//  Created by umer hamid on 10/18/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class RegistrationViewController: UIViewController ,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
 
     
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    let general = GeneralFunction()
    var currentUserID = ""
    
    let image = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
 
    }


    @IBAction func registrationButtonPressed(_ sender: Any) {
        
        let registeration = RegistrationModel()
        self.view.makeToastActivity(.center)
        
        registeration.completeRegistration(email: emailTextField.text!, password: passwordTextField.text!, phone: mobileTextField.text!, name: nameTextField.text!, controller: self, collection: "User", image: profileImage){ (responseMsg) in
            
            //print("response Message : \(responseMsg)")
            
            
            if responseMsg != "sucessFull"{
                self.view.hideToastActivity()

                self.general.showMessage(title: "Result", msg: responseMsg, on: self)
            }else{
                self.general.showMessage(title: "Result", msg: responseMsg, on: self)
                self.view.hideToastActivity()
                self.performSegue(withIdentifier: "goToFriendList", sender: self)
                self.currentUserID = Auth.auth().currentUser!.uid
                emailG = self.emailTextField.text!
            }
            
        }

    }
    
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFriendList"{

            let friendVC = segue.destination as! FriendsTableViewController
            friendVC.currentUserID = self.currentUserID
            
        }
    }


}



extension RegistrationViewController{
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            
            print("tapped in image")
            image.delegate = self
            image.sourceType = .camera
            image.allowsEditing = false
            present(image, animated: true, completion: nil)
            
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                 
         
         if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            
            print(UIImagePickerController.InfoKey.originalImage.rawValue)
             
            profileImage.image = imagePicked
     
             }
        
         self.dismiss(animated: true, completion: nil)
    }
    
}

