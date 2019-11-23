//
//  LoginModel.swift
//  ChatApp
//
//  Created by umer hamid on 11/4/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Toast_Swift

class LoginModel  {
    
    let v = Validation()
    let g = GeneralFunction()
    
    func login(email : String , password : String , controller : UIViewController, completion: @escaping (_ responseMsg: String , _ userID : String )-> Void){
        
        
       let email =  v.isValidEmailAddress(emailAddressString: email, controller: controller)
        if email == "" {
            
            
            g.showMessage(title: "Error", msg: "Email is invalid", on: controller)
            
        }else{
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                          
                          if error != nil {
                           
                           completion("error" , "")
                             // print(error!)
                          
                            self.g.showMessage(title: "Error", msg: "\(error!.localizedDescription)", on: controller)
                          } else {
                             //completion("login successfull")
                            
                            let userID = Auth.auth().currentUser?.uid
                            //print(user)
                            
                            
                             
                           if let userID = userID {
                            
                          let data = ["IsOnline": true]
                            self.f.updateData(collection: "User", data: data, documentID: userID) { (response) in
                                completion(response , userID)
                               
                             //self.performSegue(withIdentifier: "LoginToChat", sender: self)
                                                    
                            }
                            
                        }

                            
                           
//
                            }
                       }
            
        }
        
       
    }
    
    
    let f = FireStoreQueries()
    
    
 
}
