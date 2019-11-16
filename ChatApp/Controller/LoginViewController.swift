//
//  LoginViewController.swift
//  ChatApp
//
//  Created by umer hamid on 11/4/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    var db : Firestore!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var currentUserID = ""
    
    let l = LoginModel()
    let general = GeneralFunction()
    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
                      // [END setup]
        db = Firestore.firestore()
    }
    
    var arrFriendID = [String]()
    @IBAction func loginButtonPressed(_ sender: Any) {
        
   
        
       // self.getFriendsIDs()
        self.view.makeToastActivity(.center)

        l.login(email: emailTextField.text!, password: passwordTextField.text!, controller: self) { (response , userID) in

            self.view.hideToastActivity()
            self.currentUserID = userID
            self.performSegue(withIdentifier: "loginToChat", sender: self)
            //self.general.showMessage(title: "Result", msg: response, on: self)

            emailG = self.emailTextField.text!

            //print("here is login \(userID)")

           // print("\(self.currentUserID)")

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "loginToChat" {
            let friendVC = segue.destination as! FriendsTableViewController
            friendVC.currentUserID = self.currentUserID
           // friendVC.arrFriendIDs = self.arrFriendID


        }
    }
    

  



}
