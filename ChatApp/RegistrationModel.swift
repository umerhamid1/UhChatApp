//
//  RegistrationModel.swift
//  ChatApp
//
//  Created by umer hamid on 11/4/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import Foundation

import Firebase

class RegistrationModel {
    
     let query = FireStoreQueries()
    let general = GeneralFunction()
    let valida = Validation()
    
    func completeValidation(email : String , password : String , phone : String = "" , name : String = "", controller : UIViewController) -> (email : String , password : String , phone : String , name : String) {
        
        let email =  valida.isValidEmailAddress(emailAddressString: email, controller: controller)
        let password = valida.isValidPassword(value: password, controller: controller)
        let phone = valida.isValidatePhone(value: phone, controller: controller)
        let name = valida.isValidName(value: name, controller: controller)
        return (email, password, phone, name)
    }
    func completeRegistration (email : String , password : String , phone : String , name : String , controller : UIViewController , collection : String , image : UIImageView , completion: @escaping (_ responseMsg: String )-> Void ) {
        
        //var data = [String : Any]()
        
        
        let email =  valida.isValidEmailAddress(emailAddressString: email, controller: controller)
        let password = valida.isValidPassword(value: password, controller: controller)
        let phone = valida.isValidatePhone(value: phone, controller: controller)
        let name = valida.isValidName(value: name, controller: controller)
        
        
        if name == "" && email == "" && phone == "" && password == ""{
            general.showMessage(title: "Error", msg: "invalid Details", on: controller)
        }else{
             //general.showMessage(title: "Error", msg: "data is valid", on: controller)
                    var data = [
                               "Name"  : name,
                               "Email" : email,
                               "Phone" : phone,
                              // "Date"   : Date(),
                               "IsOnline" : true,
                               "ImageURL" : "",
                               "ConversationID" : ["","",""]
            
                        ] as [String : Any]
            var msg = ""
            registerUser(email: email, password: password, collection: collection, data: data, image: image) { (responseMsg) in
                msg = responseMsg
                completion(responseMsg)
                print("reponse messge of register user : \(msg)")
            }
            
           // completion(msg)
        }
        
        
       
    }
    
    
        func registerUser(email : String , password : String ,collection : String ,data : [String : Any] , image : UIImageView , completion: @escaping (_ responseMsg: String )-> Void )
        {
            
           // var repson = ""
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if error != nil  {
                    
                    completion("\(error!.localizedDescription)")
                    
                }else{
                    
                   
                  let userID = Auth.auth().currentUser?.uid
                                             
                                              
                  
                                              
                    self.query.insertData(collection: collection, data: data , collectionID: userID!) { (responseMsg, documentID) in
                        completion(responseMsg)
                        
                        self.query.imageUpload(image: image , imageID:  documentID , data : data , collection: collection) { (response) in
                            
                            print("image upload message \(responseMsg)")
                            completion(response)

                        }
                    }
                    
            }
                       
                       
                        
                       
                       
                   
        }
    }
    
}
