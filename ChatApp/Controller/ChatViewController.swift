//
//  ChatViewController.swift
//  ChatApp
//
//  Created by umer hamid on 11/7/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import YPImagePicker


class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    

    
    var db : Firestore!
    var senderUserID = ""
    var receiverUserID = ""
    var receiverName = ""
    var receiverImageURL = ""
    var conversationID = ""
    
    
    // here is new
    
    var cellHeight:CGFloat!
    var bottomConstraint: NSLayoutConstraint?
    var alertView: UIAlertController!
  //  var progressDownload: UIProgressView
    // end new
    
    
    var messageArray : Array = [Message]()
   // let currentUserID = Auth.auth().uid

    //@IBOutlet var heightConstraint: NSLayoutConstraint!
    //@IBOutlet var sendButton: UIButton!
    //@IBOutlet var messageTextfield: UITextField!
    //@IBOutlet var messageTableView: UITableView!
  //  @IBOutlet weak var navBar: UINavigationItem!
    
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextfield: UITextView!
    @IBOutlet weak var sendButton: UIButton!
   // @IBOutlet weak var navBar: UINavigationItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        print(receiverName)
//        print(receiverImageURL)
//        print(receiverUserID)
        
        print("here is current user ID \(senderUserID)")
        
        let settings = FirestoreSettings()

            Firestore.firestore().settings = settings
            // [END setup]
            db = Firestore.firestore()
        
     
         
        
       // navBar.title = receiverName
        messageTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil) , forCellReuseIdentifier: "receiverMessageCell")
        
        messageTableView.register(UINib(nibName: "senderTableViewCell", bundle: nil) , forCellReuseIdentifier: "senderMessageCell")
        
        //  messageTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil) , forCellReuseIdentifier: "FriendCell")
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
      
        
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 44
        
        
       // messageTableView.register(UINib(nibName: "MessageCell2", bundle: nil) , forCellReuseIdentifier: "customMessageCell2")
        
        messageTableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
        getMessages()
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.onlySquareImagesFromCamera = false
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .photo
            config.screens = [.library, .photo]
            config.wordings.cameraTitle = "Camera"
            config.wordings.libraryTitle = "Photos"
            config.showsPhotoFilters = true
            config.wordings.save = "Send"
            config.showsCrop = .rectangle(ratio: 1.0)
            
            var imagePicked = false
            
            let picker = YPImagePicker(configuration: config)
        
            picker.didFinishPicking { [unowned picker] items, _ in
                
//                if let img = items.singlePhoto?.image{
//                    self.userActivityObj.sendPicture(sid: self.uid!, rid: self.recvId!, sName: self.uName!, rName: self.recvName, _message: img, completion: {(error,msg) in
//
//                        if let err = error{
//                            let alert = UIAlertController(title: "Alert", message: err, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//
//                    })
//                    imagePicked = true
//                }
                picker.dismiss(animated: true, completion: {() in
                    if imagePicked{
                        self.showSendProgress()
                    }
                })
            }
            present(picker, animated: true, completion: nil)
        
        
    }
    
    func showSendProgress(){
        
           self.alertView = UIAlertController(title: "Sending", message: "0%", preferredStyle: .alert)
           alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in
               staticLinker.uploadProgress.cancel()
               staticLinker.uploadProgress.removeAllObservers()
           }))
           //self.progressDownload = UIProgressView(progressViewStyle: .default)
           //self.progressDownload.setProgress(0.0, animated: true)
           //self.progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
           //alertView.view.addSubview(progressDownload)
           
           self.present(alertView, animated: true, completion: nil)
           
           staticLinker.uploadProgress.observe(.progress) { snapshot in
               if let error = snapshot.error{
                   self.alertView.title = "Error"
                   self.alertView.message = error.localizedDescription
                   self.dismiss(animated: true, completion: nil)
               }else{
                   //self.progressDownload.setProgress(Float(snapshot.progress!.fractionCompleted), animated: true)
                   self.alertView.message = String(Int(snapshot.progress!.fractionCompleted * 100))
                   if Int(snapshot.progress!.fractionCompleted * 100) == 100{
                       self.dismiss(animated: true, completion: nil)
                   }
               }
               
           }
       }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
                  try Auth.auth().signOut()

                  navigationController?.popToRootViewController(animated: true)

              }
              catch {
                  print("error: there was a problem logging out")
              }
    }
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        print("starrt update array ")
       
        
               messageTextfield.endEditing(true)
              // messageTextfield.isEnabled = false
               sendButton.isEnabled = false
                   
               
           var msg = self.messageTextfield.text!
               
          
               if friendID == "" {

                   var ref: DocumentReference? = nil
                   ref = db.collection("Friends").addDocument(data: [
                    "ConversationID" : self.conversationID,
                    "LastMessage" : msg,
                    "LastMessageTime" : Date(),
                    "ConversationName" : "",
                    "ConversationCreatedDate" : Date(),
                    
                    "User1": self.senderUserID,
                    "User2": self.receiverUserID

                   ]) { err in
                       if let err = err {
                           print("Error adding document: \(err)")

                       } else {

                           print("Document added with ID: \(ref!.documentID)")
                           self.friendID = ref!.documentID
                        
//                       self.db.collection("User").document(self.senderUserID).updateData([
//                            "ConversationID": FieldValue.arrayUnion(["chck"])
//                        ])
                        
                        self.db.collection("User").document(self.senderUserID).updateData([ "ConversationID": FieldValue.arrayUnion([self.friendID])]){ err in
                                   if let err = err {
                                       print("Error adding document: \(err)")

                                   } else {

                                       print("new document is added array")
                                       //print("here Friend ID : \(self.friendID)")
                                       //print("Document added with ID: \(ref1!.documentID)")
                                       
                                      // self.retrieveMessages()

                                   }
                               }
                        
                        self.db.collection("User").document(self.receiverUserID).updateData([ "ConversationID": FieldValue.arrayUnion([self.friendID])]){ err in
                                                          if let err = err {
                                                              print("Error adding document: \(err)")

                                                          } else {

                                                              print("new document is added array")
                                                              //print("here Friend ID : \(self.friendID)")
                                                              //print("Document added with ID: \(ref1!.documentID)")
                                                              
                                                             // self.retrieveMessages()

                                                          }
                                                      }
                           
                           var ref1: DocumentReference? = nil
                           ref1 = self.db.collection("Messages").addDocument(data: [
                                            
                            "ConversationID" : self.conversationID,
                            "FriendID" : ref!.documentID,
                            "MsgType" : "text",
                            "Uid" : self.senderUserID,
                            "Date" : Date(),
                            "msgBody" : msg
                                           //  "Sender": loginEmail ,
                                            // "Receiver": self.emailReceiver ,



                                         ]) { err in
                                             if let err = err {
                                                 print("Error adding document: \(err)")

                                             } else {

                                                 print("here Friend ID : \(self.friendID)")
                                                 print("Document added with ID: \(ref1!.documentID)")
                                                 
                                                // self.retrieveMessages()

                                             }
                                         }
                        
                           
                          // print("here Friend ID : \(self.friendID)")
                          // self.retrieveMessages()

                       }
                   }
                

                
                   
               }else {
                   var ref1: DocumentReference? = nil
                                 ref1 = db.collection("Messages").addDocument(data: [
                                    
                                            "ConversationID" : self.conversationID,
                                            "FriendID" : self.friendID,
                                            "MsgType" : "text",
                                            "Uid" : self.senderUserID,
                                            "Date" : Date(),
                                            "msgBody" : msg


                                 ]) { err in
                                     if let err = err {
                                         print("Error adding document: \(err)")

                                     } else {

                                         print("here Friend ID : \(self.friendID)")
                                         print("Document added with ID: \(ref1!.documentID)")
                                         
                                        // self.retrieveMessages()

                                     }
                                 }
               }
               
        
                   

              
             
               
               
                     
            
           
          

                  // self.messageTextfield.isEnabled = true
                   self.sendButton.isEnabled = true
                   self.messageTextfield.text = ""

        
        
    }
    
    var friendID = ""
    
    func getFrieldID(completion : @escaping (_ friendId : String)->Void) {

            print("start take friend ID")
            
            db.collection("Friends").whereField("ConversationID", isEqualTo: conversationID)
                
                .addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        
                        for document in querySnapshot!.documents {
                            self.friendID = document.documentID
                            print("here is FriendID document : \(document.documentID) => \(document.data())")
                            print("here is self.fried id : \(self.friendID) ")
                            completion(self.friendID)
                        }
                        
                    }
                    
        }
        
    }
    
    func getMessages(){
    
        getFrieldID { (friendID) in
            if friendID == "" {
                print("friend id is nil inside in fucntion")
            }else{
                 self.realTimeUpdate()
                
            }
                        
         }
            
    }
    
    func realTimeUpdate(){
        
        db.collection("Messages").whereField("FriendID", isEqualTo: friendID).order(by: "Date", descending: false)
                  .addSnapshotListener { querySnapshot, error in
                      guard let snapshot = querySnapshot else {
                          print("Error fetching snapshots: \(error!)")
                          return
                      }
                      snapshot.documentChanges.forEach { diff in
                          if (diff.type == .added) {
                              print("New city: \(diff.document.data())")
    
                            let m = Message()
                            let data = diff.document.data()
                            m.conversationID = data["ConversationID"] as! String
                            m.friendID = data["FriendID"] as! String
                            m.msgType = data["MsgType"] as! String
                            m.uid = data["Uid"] as! String
                            m.date = data["Date"] as? Date
                            m.messageBody = data["msgBody"] as! String
                           // m.receiver = data["Receiver"] as! String
                           // m.sender = data["Sender"] as! String
                            self.messageArray.append(m)
                            print("here is forach realtime update")
                              
                              self.messageTableView.beginUpdates()
                              self.messageTableView.insertRows(at: [IndexPath(row: self.messageArray.count-1, section: 0)], with: .automatic)
                              self.messageTableView.endUpdates()
                              self.scrollToBottom()
                          }
                          print("here is out side forach realtime update")
                         
                      }
                  }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
        
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    var i = 0
           
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
       
        
        if senderUserID == messageArray[indexPath.row].uid {
            i = 1
            //receiverMessageCell
             let cell = tableView.dequeueReusableCell(withIdentifier: "receiverMessageCell", for: indexPath) as! ReceiverTableViewCell
            cell.messageBody.text = messageArray[indexPath.row].messageBody
            cell.selectionStyle = .none
                 var url  = NSURL(string: receiverImageURL)
                 
                  cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                // cell.avatarImageView.backgroundColor = UIColor.red
            cell.senderUsername.text = "umer hamid"
            print("i == 0 ")
            return cell
            
        }else{
            print("i == 1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderMessageCell", for: indexPath) as! senderTableViewCell
            cell.messageBody.text = messageArray[indexPath.row].messageBody
                 
                 var url  = NSURL(string: receiverImageURL)
                 
                  cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                // cell.avatarImageView.backgroundColor = UIColor.red
            cell.senderUsername.text = self.receiverName
            cell.selectionStyle = .none
            return cell
        }
        
        
        
         
        
        

     
        
        
//        func creatConversationID(){
//            let user = Auth.auth().currentUser
//            if let user = user {
//
//              let uid = user.uid
//
//                var conversationID = ""
//                if uid > receiverUserID {
//
//                    conversationID = uid + receiverUserID
//
//                }else{
//                     conversationID =   receiverUserID + uid
//                }
//
//                print(conversationID)
//
//            }
//        }
        
        
        
        
       // return cell

//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
//
//             // let url = NSURL(string: arr[indexPath.row].ImageURL!)
//
//             // cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
//
//              cell.senderUsername.text = "sadf"
//              cell.lastMessageTime.text = "asdf"
//              cell.lastMessageText.text = "sdfa"//arr[indexPath.row].Email
//               return cell


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
