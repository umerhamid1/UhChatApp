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

var emailG = ""

class FireStoreQueries : UIViewController{
    
    var general = AppDelegate()
    //let general = UIApplication.shared
    
    let g = GeneralFunction()

    
    var  db = Firestore.firestore()
    var ref: DocumentReference?
    
    let uid = Auth.auth().currentUser?.uid
    
    func sendAudio( sid:String, rid:String,  _message:String, duration:String, completion: @escaping (_ response: String?) -> ()){
        let formattedDate = String(Date().timeIntervalSince1970)
        var chatId = String()
        if sid > rid{
            chatId = sid + rid
        }else{
            chatId = rid + sid
        }
        self.uploadAudio(audioPath: _message, completion: {(error,url) in
            var ref:DocumentReference?
            if let err = error{
                completion(err)
            }else if let Url = url{
                ref = self.db.collection("Messages").addDocument(data:
                    [
                       
                                      "ConversationID" : chatId,
                                      "FriendID" : rid,
                                       "MsgType" : "audio",
                                       "Uid" : sid,
                                       "Date" : Date(),
                                        "msgBody" : Url.absoluteString,
                        "duration" : duration


                    ]
                    
                   // ["sid":sid,"rid":rid,"sName":sName, "rName":rName,"sDel":"false", "rDel":"false", "duration":duration,"message":Url.absoluteString,"type":"audio","date":formattedDate,"chatId":chatId]
                    
                    , completion: {(error) in
                    if let err = error{
                        completion(err.localizedDescription)
                    }else{
                        completion("ok")
//                        if let err = error{
//                            completion(err.localizedDescription)
//                        }
                      //  else {
//                            self.addToChat(formattedDate: formattedDate, chatId: chatId, sid: sid, rid: rid, sName: sName, rName: rName, message: Url.absoluteString, type: "audio", duration: duration, completion: {(error) in
//                                if let err = error{
//                                    completion(err,nil)
//                                }else{
//                                    let msg = message(date: formattedDate, message: Url.absoluteString, rDel: "false", rid: rid, rName: rName, sDel: "false", sid: sid, sName: sName, type: "audio", messageId: ref!.documentID, chatId: chatId, duration: duration)
//                                    completion(nil, msg)
//                                }
//                            })
                        //}
                    }
                })
            }
        })
    }
    
    
    func uploadAudio(audioPath:String?, completion: @escaping (_ error: String?,_ url:URL?) -> ()){
         if staticLinker.uploadProgress != nil{
             staticLinker.uploadProgress.removeAllObservers()
         }
         let audioUpload = Storage.storage().reference().child("audio/\(UUID())\(uid!)")
         staticLinker.uploadProgress = audioUpload.putFile(from: URL(string: audioPath!)!, metadata: nil, completion: { (metadata, error) in
             if let err = error {
                 completion(err.localizedDescription,nil)
             }else{
                 audioUpload.downloadURL(completion: { (url, error) in
                     if let err = error {
                         completion(err.localizedDescription,nil)
                     }else{
                         completion(nil,url)
                     }
                 })
             }
         })
     }
    
    func getFriendsIDs(email : String){
        var arrFriendID : Array = [String]()
        
       db.collection("User").whereField("Email", isEqualTo: email)
       .addSnapshotListener { querySnapshot, error in
           guard let snapshot = querySnapshot else {
               print("Error fetching snapshots: \(error!)")
               return
           }
           snapshot.documentChanges.forEach { diff in
            //   if (diff.type == .added) {
                   print("New city: \(diff.document.data())")
                let data = diff.document.data()
                var arr = data["ConversationID"] as! Array<String>
                print("here is conversation ID : \(arr)")
                
            //   }
            
           }
        
       }
       
       
       }
    
    let dg = DispatchGroup()
    
    
    
    
    func getCurrentUserDetail(completion : @escaping(_ UserID : String , _ imageURL : String ,_ currentUserName : String)->Void){
        let userID = Auth.auth().currentUser?.uid
        
       
       // let docRef = db.collection("User").document(userID!)

        db.collection("User").whereField("Email", isEqualTo: emailG)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let uid = userID
                        let data = document.data()
                        let imageURL = data["ImageURL"] as! String
                        let name = data["Name"] as! String
                       
                        print(imageURL)
                        //print("\(document.documentID) => \(document.data())")
                        print("data is excuted")
                        completion(uid! , imageURL , name)
                       
                    }
                    
                }
        }

    }
    
    
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
