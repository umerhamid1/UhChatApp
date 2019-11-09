//
//  FireStoreQueries.swift
//  ChatApp
//
//  Created by umer hamid on 11/2/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import Toast_Swift
//import CodableFirebase

class FireStoreQueries : UIViewController{
    
    var general = AppDelegate()
    //let general = UIApplication.shared
    
    let g = GeneralFunction()

    
    var  db = Firestore.firestore()
    var ref: DocumentReference?
    
    
    let dg = DispatchGroup()
    
    func check(t : String = "" , ok : Int)  {
        print()
    }
    
    func insertData(collection : String , data : [String : Any ] ,collectionID : String, completion: @escaping (_ responseMsg: String , _ documentID : String)-> Void ){
        
    
        // Add a new documents.

      db.collection(collection).document(collectionID).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        self.db.collection(collection).document(collectionID).setData(data)
            { err in
                if let err = err {

                    completion(err.localizedDescription as! String , "")

                } else {

                    //print("Document added with ID: \(self.ref!.documentID)")

                    //completion("sucessFull" , self.ref!.documentID)
                    completion("sucessFull" , collectionID)


                }

            }
        
                    
    }
    func updateData(collection : String , data : [String : Any] , documentID : String , completion: @escaping (_ responseMsg: String)-> Void ){
        
        var response = ""
        db.collection(collection).document(documentID).setData(data ,  merge: true) { err in
            if let err = err {
                response = "\(err.localizedDescription)"
                //print("Error writing document: \(err)")
                completion(response)
            } else {
                response = "SucessFull Upated"
                print("Document successfully written!")
                completion(response)
            }
        }
        
    }
    
    
    
    // search
    func updateConversationID(collection : String , collectionID : String, conversationID : String , currentUserID : String){
        
      //  let citiesRef = db.collection(collection).document(collectionID).
            
      //      citiesRef.whereField("state", isEqualTo: "CO")
      //
                // .whereField("name", isEqualTo: "Denver")
             
        
        
    }
    // here all app user detail
    
    
    
    func allUserDetail(collection : String, controller : UIViewController , completion : @escaping (_ arr : [User])-> Void){
        var u = User()
              
        var userArr = [User]()
      
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
                      // [END setup]
        
        self.db = Firestore.firestore()
        
        db.collection(collection).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                self.g.showMessage(title: "Error", msg: "\(err.localizedDescription)", on: controller)
                //print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                   // if collection == "User"{
                        
                        let data = document.data()
                                           
                        u.ConversationID = data["ConversationID"] as? Array ?? ["nil"]
                        u.Email = data["Email"] as? String ?? "nil"
                        u.ImageURL = data["ImageURL"] as? String ?? "nil"
                        u.ISOnline = data["IsOnline"] as? Bool ?? false
                        
                        u.Name = data["Name"] as? String ??  "nil"
                        u.Phone = data["Phone"] as? String ?? "nil"
                        u.UserID = document.documentID
                        
                        userArr.append(u)
                        
                       // print(userArr)
                        
                       // print("\(document.documentID) => \(document.data())")
                //    }
                
                   
                }
            completion(userArr)
            }
            
        }
        
       
    }
 
    
    func imageUpload(image : UIImageView , imageID : String , data : [String : Any] , collection : String ,completion: @escaping (_ responseMsg: String )-> Void ){

                    let storage =
                        Storage.storage().reference().child("\(imageID)profileImage.png")
                  //  if let image = profileImage.image {
        
        
        if let image = image.image{
           // UIImagePNGRepresentation(self , )
            
            if let imageData = image.jpeg(.lowest) {
                print(imageData.count)
           // }
                        //if let data = image.pngData() {
        
                            var errr = ""
                            
                            storage.putData(imageData, metadata: nil) { (metaData, error) in
                                if error != nil {
                                    // here is error
                                  //  print(error)
                                    errr = error!.localizedDescription
                                    completion(errr )
                                }else {
                                    storage.downloadURL { (url, error) in
                                        
                                    guard let downloadURL = url else {
                                        return
                                        }
                                        
                                       // var res = ""
                                        
                                        var updateData = data
                                        updateData["ImageURL"] = downloadURL.absoluteString
                                        
                                          self.updateData(collection: collection, data: updateData , documentID: imageID) { (finalMessage) in
                                            errr = "registration is completed"
                                            completion(errr)
                                        }
                                      //  updateData(collection: "User", data: , documentID: <#T##String#>, completion: <#T##(String) -> Void#>)
                                        //var url = NSString(downloadURL)
//                                        print(" download url : \(downloadURL)")
//                                        print("  url  absoute: \(url!.absoluteString)")
//                                        print(" download url with absolute  : \(downloadURL.absoluteString)")
                                        
                                        
                                       // completion(errr)
                                        
                                     }
                          
                                }
                         }
                    
            
            }
    }
    }
    
    
    
    
    func resetPassword(email :String , completion : @escaping (_ response : String)->Void){
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                //callback?(error)
                completion("\(error.localizedDescription)")
            }else{
                completion("Email has been Sent check your Email")
            }
            
         // print(error)
        }
    }
    


}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
