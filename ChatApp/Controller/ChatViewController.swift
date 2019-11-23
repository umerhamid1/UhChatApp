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
import AVFoundation
import Foundation
import AudioToolbox
import GrowingTextView
import IQKeyboardManagerSwift

class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    
    
    
    var db : Firestore!
    var senderUserID = ""
    var receiverUserID = ""
    var receiverName = ""
    var receiverImageURL = ""
    var conversationID = ""
    var senderUserName = ""
    var senderImageURL = ""
    var receiverOnlineStatus = false
    var firstTimeLoad = false
    
    // here is audio session
    
    private var bringMore = false
    private var selectedIndex:IndexPath!
    private var initiate = false
    private var initiate1 = false
    var audioPlayer:AVPlayer!
    var play = UIImage(named: "play")
    var pause = UIImage(named: "pause")
    var audioButton:UIButton!
    var progressDownload: UIProgressView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    
    var  receiverDocumentID = ""
    var senderDocumentID = ""
    @IBOutlet weak var recordButton: UIButton!
    
    // end audio session
    
    
    
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
    
    @IBOutlet var messageTextfield: UITextField!
    //@IBOutlet var messageTableView: UITableView!
    //  @IBOutlet weak var navBar: UINavigationItem!
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageTableView: UITableView!
    
    // @IBOutlet weak var messageTextfield: GrowingTextView!
    @IBOutlet weak var sendButton: UIButton!
    // @IBOutlet weak var navBar: UINavigationItem!
    
    let fs = FireStoreQueries()
    let gf = GeneralFunction()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getFrieldID {
            print("here is friendID : \(self.senderDocumentID)")
            print("here is receiver document iD : \(self.receiverDocumentID)")
            
        }
        
        self.navigationItem.title = "\(self.receiverName)"
        
        messageTextfield.layer.cornerRadius = 15.0
        bottomConstraint = NSLayoutConstraint(item: containerView!, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        
        //messageTextfield.delega
        //        messageTextfield.maxLength = 140
        //        messageTextfield.trimWhiteSpaceWhenEndEditing = false
        //        messageTextfield.placeholder = "Type Message..."
        //        messageTextfield.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        //        messageTextfield.minHeight = 25.0
        //        messageTextfield.maxHeight = 70.0
        //        //messageTextfield.backgroundColor = UIColor.whiteColor()
        //        messageTextfield.layer.cornerRadius = 4.0
        automaticallyAdjustsScrollViewInsets = false
        // recordButton.setImage(UIImage(named: "pause.circle"), for: .normal)
        
        
        
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
        
        messageTableView.register(UINib(nibName: "imageTableViewCell", bundle: nil) , forCellReuseIdentifier: "senderImageCell")
        messageTableView.register(UINib(nibName: "receiverImageTableViewCell", bundle: nil) , forCellReuseIdentifier: "receiverSendingImageCell")
        
        messageTableView.register(UINib(nibName: "AudioTableViewCell", bundle: nil) , forCellReuseIdentifier: "audioCell")
        
        messageTableView.register(UINib(nibName: "audioSendersTableViewCell", bundle: nil) , forCellReuseIdentifier: "audioSenderCell")
        
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        
        
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 44
        
        
        // messageTableView.register(UINib(nibName: "MessageCell2", bundle: nil) , forCellReuseIdentifier: "customMessageCell2")
        
        messageTableView.separatorStyle = .none
        
        // gf.showMessage(title: "test", msg: "userName : \(senderUserName)url : \(senderImageURL) userID : \(senderUserID)", on: self)
        
        // Do any additional setup after loading the view.
        getMessages()
        
        // audio setup
        // self.setUpNavigationBar()
        //self.configureUI()
        self.setupAudioSession()
        // self.recordButton.addTarget(self, action: #selector(holdRelease), for: UIControl.Event.touchUpInside);
        
        //
        recordButton.setImage(UIImage(named: "mic111.png"), for: .normal)
        
        
        var data = [
            
            "ConversationID" : self.conversationID,
            "LastMessage" : "testing changed111",
            "LastMessageTime" : Date(),
            "ConversationName" : "",
            "ConversationCreatedDate" : Date(),
            "User1": self.senderUserID,
            "user1Name/sender" : self.senderUserName,
            "IsOnline/sender" : true ,
            "imageURL/sender" : senderImageURL,
            "User2": self.receiverUserID,
            "IsOnline/Receiver" : receiverOnlineStatus,
            "user2Name/receiver" : self.receiverName,
            "imageURL/receiver" : self.receiverImageURL,
            "CollectionID" : "",
            "duration" : ""
            ] as! [String : Any]
        
        var refFriends : DocumentReference? = nil
        //                      // self.db.collection("User")
        //                      self.db.collection(["User", senderUserID, "Friends"].joined(separator: "/")).addDocument(data: data){ error in
        //
        //                          if let e = error {
        //                               print("Error sending message: \(e.localizedDescription)")
        //                               return
        //                          }else{
        //                              print("data is added in user - > thread")
        //                          }
        //
        //
        
        
        
        //        db.collection(["User", senderUserID, "Friends" ].joined(separator: "/")).document("b3t4Op4GRFMYp6SbCfNXIWeTvLB2").setData(data
        //
        //
        //         ) { err in
        //              if let err = err {
        //
        //                  print("Error writing document: \(err.localizedDescription)")
        //
        //              } else {
        //                  print("Document successfully written!")
        //
        //              }
        //        }
        
        //        db.collection(["User", senderUserID, "Friends" ].joined(separator: "/")).order(by: "LastMessageTime", descending: true).addSnapshotListener { (result, error) in
        //            if let error = error {
        //                print("here is error")
        //            }else{
        //                print("data is updated")
        //            }
        //        }
    }
    
    func newFriendIsAdd(senderData : [String : Any], receiverData : [String : Any] , senderID : String, receiverID : String){
        
        // sender Friend List
        self.db.collection(["User", senderID, "Friends"].joined(separator: "/")).addDocument(data: senderData){ error in
            
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }else{
                print("data is added in user - > thread")
            }
        }
        
        // Receiver FriendList
        
        self.db.collection(["User", receiverID, "Friends"].joined(separator: "/")).addDocument(data: receiverData){ error in
            
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                //return
            }else{
                print("data is added in receiver id :  - > thread")
                
                
            }
        }
        
        
    }
    
    func updateFriendMessages( senderDocumentID : String , receiverDocumentID : String , senderID : String , receiverID : String, senderData : [String: Any] , receiverData : [String : Any]){
        
        db.collection(["User", senderID, "Friends" ].joined(separator: "/")).document(senderDocumentID).setData(senderData , merge: true) { err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
                
            } else {
                print("Document successfully written!")
            }
        }
        db.collection(["User", receiverID, "Friends" ].joined(separator: "/")).document(receiverDocumentID).setData(receiverData , merge: true) { err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
                
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2436, 2688, 1792:
                    bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height + self.view.safeAreaInsets.bottom : 0
                default:
                    bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
                }
            }
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {(completed) in
                if isKeyboardShowing{
                    if self.messageArray.count != 0 {
                        let indexPath = IndexPath(item: self.messageArray.count - 1, section: 0)
                        self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
        }
    }
    var i1 = 0
    var micImage = UIImage(named: "mic111.png")
    
    var muteMicImage = UIImage(named: "muteMice.png")
    
    
    @IBAction func audioDidPress(_ sender: Any) {
        
        if senderDocumentID == "" {
            
            sendAudioWithOutFriendID {
                self.sendAudioWithFriendID()
            }
            print("can't send audio without freindID")
        }else
        {
            sendAudioWithFriendID()
        }
        
        
        
    }
    
    func sendAudioWithOutFriendID(completion : @escaping ()->Void){
        
        var senderData = [
            
            "ConversationID" : self.conversationID,
            "LastMessage" : "Audio",
            "LastMessageTime" : Date(),
            "ConversationName" : "",
            "ConversationCreatedDate" : Date(),
            "User1": self.senderUserID,
            "user1Name/sender" : self.senderUserName,
            "IsOnline/sender" : true ,
            "imageURL/sender" : senderImageURL,
            "User2": self.receiverUserID,
            "IsOnline/Receiver" : receiverOnlineStatus,
            "user2Name/receiver" : self.receiverName,
            "imageURL/receiver" : self.receiverImageURL,
            "CollectionID" : "",
            "duration" : ""
            ] as! [String : Any]
        
           if senderUserID == receiverUserID {
         //   senderData["user2Name/receiver"] = self.senderUserName
                     self.db.collection(["User", senderUserID, "Friends"].joined(separator: "/")).addDocument(data: senderData){ error in
                                
                                if let e = error {
                                    print("Error sending message: \(e.localizedDescription)")
                                    return
                                }else{
                                    print("data is added in user - > thread")
                                }
                            }
                     
                     
           }else{
            
        
        
        
        var receiverData = [
            
            "ConversationID" : self.conversationID,
            "LastMessage" : "Audio",
            "LastMessageTime" : Date(),
            "ConversationName" : "",
            "ConversationCreatedDate" : Date(),
            "User1": self.receiverUserID,
            "user1Name/sender" : self.receiverName,
            "IsOnline/sender" : true ,
            "imageURL/sender" : receiverName,
            "User2": self.senderUserID,
            "IsOnline/Receiver" : receiverOnlineStatus,
            "user2Name/receiver" : self.senderUserName,
            "imageURL/receiver" : self.senderImageURL,
            "CollectionID" : "",
            "duration" : ""
            ] as! [String : Any]
        
        
        
        
        newFriendIsAdd(senderData: senderData, receiverData: receiverData, senderID: self.senderUserID, receiverID: self.receiverUserID)
    }
        completion()
        
        
        
        
    }
    
    func sendAudioWithFriendID(){
        if recordButton.currentImage == micImage {
            
            recordButton.setImage(UIImage(named: "muteMice.png"), for: .normal)
            
            print("holding ")
            AudioServicesPlayAlertSound(1519)
            
            if i1 == 0 {
                i1 = 1
                self.recordAudio()
                self.recordAudio()
            }else if i1 == 1{
                self.recordAudio()
            }
            print("audio is startding")
            
        }else if recordButton.currentImage == muteMicImage{
            recordButton.setImage(UIImage(named: "mic111.png"), for: .normal)
            self.holdRelease()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // IQKeyboardManager.shared.isenable = false
        //IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    
    func holdRelease(){
        
        print("releaser")
        AudioServicesPlayAlertSound(1519)
        self.audioRecorder.stop()
        do {
            let url = URL(string: self.getDirectory().appendingPathComponent("myRecording.m4a").absoluteString)
            //print(url)
            let audioPlayer = try AVAudioPlayer(contentsOf: url!)
            let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(audioPlayer.duration))
            print(audioPlayer.duration)
            
            if Int(audioPlayer.duration) > 1{
                self.fs.sendAudio(sid: self.senderUserID, rid: self.receiverUserID, _message: url!.absoluteString,  duration:"\(m):\(s)") { (resonse) in
                    if resonse == "ok"
                    {
                        print("response completed \(resonse)")
                        
                        
                        var senderData = [
                            
                            "ConversationID" : self.conversationID,
                            "LastMessage" : "Audio",
                            "LastMessageTime" : Date(),
                            "ConversationName" : "",
                            "ConversationCreatedDate" : Date(),
                            "User1": self.senderUserID,
                            "user1Name/sender" : self.senderUserName,
                            "IsOnline/sender" : true ,
                            "imageURL/sender" : self.senderImageURL,
                            "User2": self.receiverUserID,
                            "IsOnline/Receiver" : self.receiverOnlineStatus,
                            "user2Name/receiver" : self.receiverName,
                            "imageURL/receiver" : self.receiverImageURL,
                            "CollectionID" : "",
                            "duration" : ""
                            ] as! [String : Any]
                        
                        var receiverData = [
                            
                            "ConversationID" : self.conversationID,
                            "LastMessage" : "Audio",
                            "LastMessageTime" : Date(),
                            "ConversationName" : "",
                            "ConversationCreatedDate" : Date(),
                            "User1": self.receiverUserID,
                            "user1Name/sender" : self.receiverName,
                            "IsOnline/sender" : true ,
                            "imageURL/sender" : self.receiverName,
                            "User2": self.senderUserID,
                            "IsOnline/Receiver" : self.receiverOnlineStatus,
                            "user2Name/receiver" : self.senderUserName,
                            "imageURL/receiver" : self.senderImageURL,
                            "CollectionID" : "",
                            "duration" : ""
                            ] as! [String : Any]
                        
                        self.updateFriendMessages(senderDocumentID: self.senderDocumentID, receiverDocumentID: self.receiverDocumentID, senderID: self.senderUserID, receiverID: self.receiverUserID, senderData: senderData, receiverData: receiverData)
                        
                        
                        
                        
                    }else{
                        print("error during uuploading audio")
                    }
                    
                }
                //                self.userActivityObj.sendAudio(sid: self.uid!, rid: self.recvId!, sName: self.uName!, rName: self.recvName, _message: url!.absoluteString, duration:"\(m):\(s)", completion: {(error,msg) in
                //                    if let err = error{
                //                        let alert = UIAlertController(title: "Alert", message: err, preferredStyle: UIAlertController.Style.alert)
                //                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                //                        self.present(alert, animated: true, completion: nil)
                //                    }
                //                })
                showSendProgress()
            }
        } catch {
            assertionFailure("Failed crating audio player: \(error).")
        }
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        if senderDocumentID == "" && receiverDocumentID == "" && senderUserID == receiverUserID{
            
            sendPictureWithOutFriendID {
                self.sendPictureWithFriendID()
            }
        }else if senderDocumentID == "" && receiverDocumentID == "" && senderUserID != receiverUserID{
            
            sendPictureWithOutFriendID {
                self.sendPictureWithFriendID()
            }
        }else if senderDocumentID != "" && receiverDocumentID != ""{
            sendPictureWithFriendID()
        }
        
        
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
    
    
    func  updateCoversationID(){
        
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
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        print("starrt update array ")
        
        
        
        
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        
        var msg = self.messageTextfield.text!
        
        if msg == "" {
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
            return
        }
        
        var senderData = [
            
            "ConversationID" : self.conversationID,
            "LastMessage" : msg,
            "LastMessageTime" : Date(),
            "ConversationName" : "",
            "ConversationCreatedDate" : Date(),
            "User1": self.senderUserID,
            "user1Name/sender" : self.senderUserName,
            "IsOnline/sender" : true ,
            "imageURL/sender" : senderImageURL,
            "User2": self.receiverUserID,
            "IsOnline/Receiver" : receiverOnlineStatus,
            "user2Name/receiver" : self.receiverName,
            "imageURL/receiver" : self.receiverImageURL,
            "CollectionID" : "",
            "duration" : ""
            ] as! [String : Any]
        
        var receiverData = [
            
            "ConversationID" : self.conversationID,
            "LastMessage" : msg,
            "LastMessageTime" : Date(),
            "ConversationName" : "",
            "ConversationCreatedDate" : Date(),
            "User1": self.receiverUserID,
            "user1Name/sender" : self.receiverName,
            "IsOnline/sender" : true ,
            "imageURL/sender" : receiverName,
            "User2": self.senderUserID,
            "IsOnline/Receiver" : receiverOnlineStatus,
            "user2Name/receiver" : self.senderUserName,
            "imageURL/receiver" : self.senderImageURL,
            "CollectionID" : "",
            "duration" : ""
            ] as! [String : Any]
        if senderDocumentID == "" && receiverDocumentID == "" && senderUserID != receiverUserID{
            
            
            newFriendIsAdd(senderData: senderData, receiverData: receiverData, senderID: self.senderUserID, receiverID: self.receiverUserID)
                           
                           var ref1: DocumentReference? = nil
                                     ref1 = self.db.collection("Messages").addDocument(data: [
                                         
                                         "ConversationID" : self.conversationID,
                                         
                                         "MsgType" : "text",
                                         "Uid" : self.senderUserID,
                                         "Date" : Date(),
                                         "msgBody" : msg,
                                         "duration" : ""
                                         
                                         
                                         
                                         
                                     ]) { err in
                                         if let err = err {
                                             print("Error adding document: \(err)")
                                             
                                         } else {
                                             
                                             //print("here Friend ID : \(self.friendID)")
                                             print("Document added with ID: \(ref1!.documentID)")
                                         }
                                     }
                       
            
            
            
            
        }else if senderDocumentID == "" && receiverDocumentID == "" &&  senderUserID == receiverUserID {
            
                        self.db.collection(["User", senderUserID, "Friends"].joined(separator: "/")).addDocument(data: senderData){ error in
                                   
                                   if let e = error {
                                       print("Error sending message: \(e.localizedDescription)")
                                       return
                                   }else{
                                       print("data is added in user - > thread")
                                   }
                               }
                        
                        var ref1: DocumentReference? = nil
                                  ref1 = self.db.collection("Messages").addDocument(data: [
                                      
                                      "ConversationID" : self.conversationID,
                                      
                                      "MsgType" : "text",
                                      "Uid" : self.senderUserID,
                                      "Date" : Date(),
                                      "msgBody" : msg,
                                      "duration" : ""
                                      ]) { err in
                                      if let err = err {
                                          print("Error adding document: \(err)")
                                          
                                      } else {
                                          
                                          print("here Friend ID : \(self.friendID)")
                                          print("Document added with ID: \(ref1!.documentID)")
                                      }
                                  }
                      
                        
                    }
                    
                //    else{
        //                newFriendIsAdd(senderData: senderData, receiverData: receiverData, senderID: self.senderUserID, receiverID: self.receiverUserID)
        //
        //                var ref1: DocumentReference? = nil
        //                          ref1 = self.db.collection("Messages").addDocument(data: [
        //
        //                              "ConversationID" : self.conversationID,
        //
        //                              "MsgType" : "text",
        //                              "Uid" : self.senderUserID,
        //                              "Date" : Date(),
        //                              "msgBody" : msg,
        //                              "duration" : ""
        //
        //
        //
        //
        //                          ]) { err in
        //                              if let err = err {
        //                                  print("Error adding document: \(err)")
        //
        //                              } else {
        //
        //                                  print("here Friend ID : \(self.friendID)")
        //                                  print("Document added with ID: \(ref1!.documentID)")
        //                              }
        //                          }
          //          }
                    
                    
                    
                    
                    
                    
                 
        
        else if senderDocumentID != "" && receiverDocumentID != "" {
            
            
            
            var ref1: DocumentReference? = nil
            ref1 = db.collection("Messages").addDocument(data: [
                
                "ConversationID" : self.conversationID,
                "FriendID" : self.friendID,
                "MsgType" : "text",
                "Uid" : self.senderUserID,
                "Date" : Date(),
                "msgBody" : msg ,
                "duration" : ""
                
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    
                } else {
                    
                    print("here Friend ID : \(self.friendID)")
                    print("Document added with ID: \(ref1!.documentID)")
                    
                    // self.retrieveMessages()
                    
                }
            }
            
            updateFriendMessages(senderDocumentID: self.senderDocumentID, receiverDocumentID: receiverDocumentID, senderID: senderUserID, receiverID: receiverUserID, senderData: senderData, receiverData: receiverData)
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        self.messageTextfield.isEnabled = true
        self.sendButton.isEnabled = true
        self.messageTextfield.text = ""
        
        
        
    }
    
    var friendID = ""
    
    func getFrieldID(completion : @escaping ()->Void) {
        
        print("start take friend ID")
        
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        db.collection(["User", senderUserID, "Friends"].joined(separator: "/")).whereField("ConversationID", isEqualTo: conversationID)
            
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    
                    for document in querySnapshot!.documents {
                        self.senderDocumentID = document.documentID
                        print("here is FriendID document : \(document.documentID) => \(document.data())")
                        print("here is self.fried id : \(self.friendID) ")
                        
                    }
                    
                }
                
        }
        
        
        
        db.collection(["User", receiverUserID, "Friends"].joined(separator: "/")).whereField("ConversationID", isEqualTo: conversationID)
            
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    
                    for document in querySnapshot!.documents {
                        self.receiverDocumentID = document.documentID
                        //   print("here is FriendID document : \(document.documentID) => \(document.data())")
                        //    print("here is self.fried id : \(self.friendID) ")
                    }
                    
                    
                }
                
        }
        
    }
    
    func getMessages(){
        
        //        getFrieldID { (friendID) in
        //            if friendID == "" {
        //                print("friend id is nil inside in fucntion")
        //            }else{
        //                 self.realTimeUpdate()
        //
        //            }
        //
        //         }
        
        
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        
        db.collection("Messages").whereField("ConversationID", isEqualTo: conversationID ).order(by: "Date", descending: false)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New test city: \(diff.document.data())")
                        print("=============================================================================")
                        
                        let m = Message()
                        let data = diff.document.data()
                        m.conversationID = data["ConversationID"] as! String
//                        m.friendID = data["FriendID"] as! String
                        m.msgType = data["MsgType"] as! String
                        m.uid = data["Uid"] as! String
                        m.date = data["Date"] as? Date
                        m.messageBody = data["msgBody"] as! String
                        m.duration  = data["duration"] as? String ?? "none"
                        // m.receiver = data["Receiver"] as! String
                        // m.sender = data["Sender"] as! String
                        self.messageArray.append(m)
                        
                        // self.messageTableView.reloadData()
                        // UIView.setAnimationsEnabled(false)
                        self.messageTableView.beginUpdates()
                        self.messageTableView.insertRows(at: [IndexPath(row: self.messageArray.count - 1, section: 0)], with: .automatic)
                        self.messageTableView.endUpdates()
                        self.scrollToBottom()
                        print("reload again")
                        
                        
                        
                        // self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.none)
                        // self.tableView.endUpdates()
                        
                    }
                }
        }
        
        
    }
    
    
    // func realTimeUpdate(){
    
    //        if firstTimeLoad == true {
    //            firstTimeLoad = false
    //              db.collection("Messages").whereField("ConversationID", isEqualTo: conversationID).order(by: "Date", descending: false).getDocuments { querySnapshot, error in
    //                                  guard let snapshot = querySnapshot else {
    //                                      print("Error fetching snapshots: \(error!)")
    //                                      return
    //                                  }
    //
    //                                  snapshot.documentChanges.forEach { diff in
    //                                    //  if (diff.type == .added) {
    //                                          //print("New city: \(diff.document.data())")
    //
    //
    //                                        let m = Message()
    //                                        let data = diff.document.data()
    //                                        m.conversationID = data["ConversationID"] as! String
    //                                        m.friendID = data["FriendID"] as! String
    //                                        m.msgType = data["MsgType"] as! String
    //                                        m.uid = data["Uid"] as! String
    //                                        m.date = data["Date"] as? Date
    //                                        m.messageBody = data["msgBody"] as! String
    //                                        m.duration  = data["duration"] as? String ?? "none"
    //                                       // m.receiver = data["Receiver"] as! String
    //                                       // m.sender = data["Sender"] as! String
    //                                        self.messageArray.append(m)
    //
    //                                        self.messageTableView.reloadData()
    //            //                              self.messageTableView.beginUpdates()
    //            //                            self.messageTableView.insertRows(at: [IndexPath(row: self.messageArray.count - 1, section: 0)], with: .automatic)
    //            //                              self.messageTableView.endUpdates()
    //                                          self.scrollToBottom()
    //                                        print("reload again")
    //                                      }
    //                                     // print("here is out side forach realtime update")
    //
    //                                //  }
    //                              }
    //
    //        }else {
    //
    
    
    //            db.collection("Messages").whereField("ConversationID", isEqualTo: conversationID )
    //                           .addSnapshotListener { querySnapshot, error in
    //                               guard let snapshot = querySnapshot else {
    //                                   print("Error fetching snapshots: \(error!)")
    //                                   return
    //                               }
    //                               snapshot.documentChanges.forEach { diff in
    //                                   if (diff.type == .added) {
    //                                       print("New city: \(diff.document.data())")
    //                                   }
    //                                   if (diff.type == .modified) {
    //                                       print("Modified city: \(diff.document.data())")
    //                                   }
    //                                   if (diff.type == .removed) {
    //                                       print("Removed city: \(diff.document.data())")
    //                                   }
    //                               }
    //                           }
    
    
    //}
    // print("updateddd")
    //messageArray.removeAll()
    
    //  }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            //UIView.setAnimationsEnabled(false)
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
            if messageArray[indexPath.row].msgType == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiverMessageCell", for: indexPath) as! ReceiverTableViewCell
                
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.selectionStyle = .none
                let url  = NSURL(string: senderImageURL)
                
                cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                // cell.avatarImageView.backgroundColor = UIColor.red
                cell.senderUsername.text = self.senderUserName
                return cell
            }else if messageArray[indexPath.row].msgType == "image" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderImageCell", for: indexPath) as! imageTableViewCell
                let urlImage  = NSURL(string: messageArray[indexPath.row].messageBody)
                cell.senderImageView.sd_setImage(with: urlImage as URL?, placeholderImage: UIImage(named: "loading.png"))
                
                //  cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.selectionStyle = .none
                let url  = NSURL(string: senderImageURL)
                
                cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                // cell.avatarImageView.backgroundColor = UIColor.red
                cell.senderUsername.text = self.senderUserName
                return cell
            }else if messageArray[indexPath.row].msgType == "audio"
            {
                //audioCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "audioSenderCell", for: indexPath) as! audioSendersTableViewCell
                // cell.playAudio()
                
                cell.tag1 = indexPath.row
                
                cell.url = messageArray[indexPath.row].messageBody
                let url  = NSURL(string: senderImageURL)
                
                cell.avatarImage.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                cell.playButtonOutLet.tag = indexPath.row
                cell.senderName.text = senderUserName
                cell.status.text = messageArray[indexPath.row].duration
                
                cell.playButtonOutLet.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
                // let data = staticLinker.getPastStatus(date: "\(self.messageArray[indexPath.row].date)")
                // cell.date.text = data.1
                //cell.status.text = staticLinker.getPastTime(for: data.0)
                
                return cell
            }
            
          
            
        }else{
            // print("i == 1")
            if messageArray[indexPath.row].msgType == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderMessageCell", for: indexPath) as! senderTableViewCell
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                
                let url  = NSURL(string: receiverImageURL)
                
                cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                // cell.avatarImageView.backgroundColor = UIColor.red
                cell.senderUsername.text = self.receiverName
                cell.selectionStyle = .none
                return cell
            }else if messageArray[indexPath.row].msgType == "audio"
            {
                //audioCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath) as! AudioTableViewCell
                
                let url  = NSURL(string: receiverImageURL)
                
                cell.avatarImage.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                cell.playButtonOutLet.tag = indexPath.row
                cell.senderName.text = receiverName
                cell.status.text = messageArray[indexPath.row].duration
                
                cell.playButtonOutLet.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
               
                
                return cell
            }
            else if messageArray[indexPath.row].msgType == "image" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiverSendingImageCell", for: indexPath) as! receiverImageTableViewCell
                let urlImage  = NSURL(string: messageArray[indexPath.row].messageBody)
                cell.receiverSenderImageView.sd_setImage(with: urlImage as URL?, placeholderImage: UIImage(named: "loading.png"))
                
                //  cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.selectionStyle = .none
                let url  = NSURL(string: receiverImageURL)
                
                cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                // cell.avatarImageView.backgroundColor = UIColor.red
                cell.senderUsername.text = self.receiverName
                return cell
                
            }
            else// if messageArray[indexPath.row].msgType == "audio"
            {
                // here is audio cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "audioSenderCell", for: indexPath) as! audioSendersTableViewCell
                cell.url = messageArray[indexPath.row].messageBody
                
                cell.senderName.text = self.receiverName
                let url  = NSURL(string: receiverImageURL)
                
                cell.avatarImage.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
                //cell.avatarImage.sd_setImage(with: <#T##URL?#>, completed: <#T##SDExternalCompletionBlock?##SDExternalCompletionBlock?##(UIImage?, Error?, SDImageCacheType, URL?) -> Void#>)
                
                
                return cell
            }
            
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioSenderCell", for: indexPath) as! audioSendersTableViewCell

        cell.senderName.text = "testing"
        let url  = NSURL(string: senderImageURL)

        cell.avatarImage.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
        //cell.avatarImage.sd_setImage(with: <#T##URL?#>, completed: <#T##SDExternalCompletionBlock?##SDExternalCompletionBlock?##(UIImage?, Error?, SDImageCacheType, URL?) -> Void#>)


        return cell
        
    }
    
    
    @objc func pressButton(_ button: UIButton) {
        if self.audioButton != button && self.audioButton != nil{
            self.audioPlayer = nil
            self.audioButton.setImage(self.play, for: .normal)
            self.audioButton = button
        }else{
            self.audioButton = button
        }
        if self.audioButton.currentImage == self.play{
            self.audioButton.setImage(self.pause, for: .normal)
            self.playSound(soundUrl: self.messageArray[button.tag].messageBody)
            audioPlayer.play()
        }else{
            self.audioButton.setImage(self.play, for: .normal)
            audioPlayer.pause()
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    func sendPicture( sid:String, rid:String,  _message:UIImage,conversationID : String, completion: @escaping (_ error: String) -> ()){
        
        //                let formattedDate = String(Date().timeIntervalSince1970)
        //                var chatId = String()
        //                if sid > rid{
        //                    chatId = sid + rid
        //                }else{
        //                    chatId = rid + sid
        //                }
        
        let  chatId = conversationID
        
        self.uploadImage(image: _message) { (error, url) in
            
            if let Url = url{
                
                var ref1: DocumentReference? = nil
                ref1 = self.db.collection("Messages").addDocument(data: [
                    
                    "ConversationID" : chatId,
                    "FriendID" : rid,
                    "MsgType" : "image",
                    "Uid" : sid,
                    "Date" : Date(),
                    "msgBody" : Url.absoluteString
                    
                    
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        completion(err.localizedDescription)
                        
                    } else {
                        
                        // print("here Friend ID : \(self.friendID)")
                        completion("ok")
                        print("image url added added with ID: \(ref1!.documentID)")
                        
                        // self.retrieveMessages()
                        
                    }
                }
                
            }else{
                
            }
        }
        
        
        
    }
    
    
    func uploadImage(image:UIImage?, completion: @escaping (_ error: String?,_ url:URL?) -> ()){
        
        let uid = Auth.auth().currentUser?.uid
        if staticLinker.uploadProgress != nil{
            staticLinker.uploadProgress.removeAllObservers()
        }
        //let data = image!.jpegData(compressionQuality: 1.0)
        let data = image!.jpeg(.lowest)
        let imageUpload = Storage.storage().reference().child("Images/\(UUID())\(uid!)/image.jpg")
        staticLinker.uploadProgress = imageUpload.putData(data!, metadata: nil) { (metadata, error) in
            if let err = error {
                completion(err.localizedDescription,nil)
            }else{
                imageUpload.downloadURL(completion: { (url, error) in
                    if let err = error {
                        completion(err.localizedDescription,nil)
                    }else{
                        completion(nil,url)
                    }
                })
            }
        }
    }
    
}


extension ChatViewController: AVAudioRecorderDelegate{
    
    
    
    func playSound(soundUrl: String)
    {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            
            try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setMode(AVAudioSession.Mode.spokenAudio)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let currentRoute = AVAudioSession.sharedInstance().currentRoute
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
                } else {
                    try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                }
            }
            
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        let url = URL(string: soundUrl)
        let item = AVPlayerItem(url: url!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        self.audioPlayer = AVPlayer(playerItem: item)
    }
    
    @objc func playerDidFinishPlaying(sender: NSNotification) {
        self.audioButton.setImage(self.play, for: .normal)
    }
    
    func recordAudio(){
        let fileName = self.getDirectory().appendingPathComponent("myRecording.m4a")
        do{
            print("here is fileName : \(fileName)")
            self.audioRecorder =  try AVAudioRecorder(url: fileName, settings: self.settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
        }catch{
            self.gf.showMessage(title: "Error", msg: "RecordingFailed", on: self)
            //self.showErrorAlert(message: "Recording Failed")
        }
    }
    
    func setupAudioSession(){
        self.recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission({(hasPermission) in
            if hasPermission{
                print("Permission Granted")
            }
        })
    }
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
extension ChatViewController{
    func sendPictureWithOutFriendID(callBack : @escaping ()->Void){
        
        var senderData = [
        
        "ConversationID" : self.conversationID,
        "LastMessage" : "Picture",
        "LastMessageTime" : Date(),
        "ConversationName" : "",
        "ConversationCreatedDate" : Date(),
        "User1": self.senderUserID,
        "user1Name/sender" : self.senderUserName,
        "IsOnline/sender" : true ,
        "imageURL/sender" : senderImageURL,
        "User2": self.receiverUserID,
        "IsOnline/Receiver" : receiverOnlineStatus,
        "user2Name/receiver" : self.receiverName,
        "imageURL/receiver" : self.receiverImageURL,
        "CollectionID" : "",
        "duration" : ""
        ] as! [String : Any]
        
        if  senderUserID == receiverUserID{
        
            
                       self.db.collection(["User", senderUserID, "Friends"].joined(separator: "/")).addDocument(data: senderData){ error in
                                  
                                  if let e = error {
                                      print("Error sending message: \(e.localizedDescription)")
                                      return
                                  }else{
                                      print("data is added in user - > thread")
                                  }
                              }
                    
                       return
        }else{
        
                       
                       var receiverData = [
                                      
                                      "ConversationID" : self.conversationID,
                                      "LastMessage" : "Picture",
                                      "LastMessageTime" : Date(),
                                      "ConversationName" : "",
                                      "ConversationCreatedDate" : Date(),
                                      "User1": self.receiverUserID,
                                      "user1Name/sender" : self.receiverName,
                                      "IsOnline/sender" : true ,
                                      "imageURL/sender" : receiverName,
                                      "User2": self.senderUserID,
                                      "IsOnline/Receiver" : receiverOnlineStatus,
                                      "user2Name/receiver" : self.senderUserName,
                                      "imageURL/receiver" : self.senderImageURL,
                                      "CollectionID" : "",
                                      "duration" : ""
                                      ] as! [String : Any]
                    
                        
               
                        
                        newFriendIsAdd(senderData: senderData, receiverData: receiverData, senderID: self.senderUserID, receiverID: self.receiverUserID)
        
        }
        callBack()
    }
    func sendPictureWithFriendID()  {
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
            
            if let img = items.singlePhoto?.image{
                
                //imageSent.se
                self.sendPicture(sid: self.senderUserID, rid: self.receiverUserID, _message: img, conversationID: self.conversationID) { (msg) in
                    if msg == "ok" {
                        
                        // self.realTimeUpdate()
                        self.updateCoversationID()
                        
                        var senderData = [
                                        
                                        "ConversationID" : self.conversationID,
                                        "LastMessage" : "Picture",
                                        "LastMessageTime" : Date(),
                                        "ConversationName" : "",
                                        "ConversationCreatedDate" : Date(),
                                        "User1": self.senderUserID,
                                        "user1Name/sender" : self.senderUserName,
                                        "IsOnline/sender" : true ,
                                        "imageURL/sender" : self.senderImageURL,
                                        "User2": self.receiverUserID,
                                        "IsOnline/Receiver" : self.receiverOnlineStatus,
                                        "user2Name/receiver" : self.receiverName,
                                        "imageURL/receiver" : self.receiverImageURL,
                                        "CollectionID" : "",
                                        "duration" : ""
                                        ] as! [String : Any]
                                    
                                    var receiverData = [
                                                   
                                                   "ConversationID" : self.conversationID,
                                                   "LastMessage" : "Picture",
                                                   "LastMessageTime" : Date(),
                                                   "ConversationName" : "",
                                                   "ConversationCreatedDate" : Date(),
                                                   "User1": self.receiverUserID,
                                                   "user1Name/sender" : self.receiverName,
                                                   "IsOnline/sender" : true ,
                                                   "imageURL/sender" : self.receiverName,
                                                   "User2": self.senderUserID,
                                                   "IsOnline/Receiver" : self.receiverOnlineStatus,
                                                   "user2Name/receiver" : self.senderUserName,
                                                   "imageURL/receiver" : self.senderImageURL,
                                                   "CollectionID" : "",
                                                   "duration" : ""
                                                   ] as! [String : Any]
                                 

                        self.updateFriendMessages(senderDocumentID: self.senderDocumentID, receiverDocumentID: self.receiverDocumentID, senderID: self.senderUserID, receiverID: self.receiverUserID, senderData: senderData, receiverData: receiverData)
                        
                    }else{
                        print("error during uploating picture")
                    }
                }
                //
                imagePicked = true
            }
            
            
            picker.dismiss(animated: true, completion: {() in
                if imagePicked{
                    self.showSendProgress()
                }
            })
        }
        present(picker, animated: true, completion: nil)
        
    }
    
}
