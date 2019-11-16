//
//  AllUserTableViewController.swift
//  ChatApp
//
//  Created by umer hamid on 11/6/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AllUserTableViewController: UITableViewController {


    var arr : Array = [User]()
   
    var receiverUserID = ""
    var receiverUserName = ""
    var receiverImageURL = ""
    @IBOutlet var allUserTableView: UITableView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fs.getCurrentUserDetail { (uid, imageURL, name) in
                  self.senderUserID = uid
                  self.senderImageURL = imageURL
                  self.senderUserName = name
              }
        
        self.view.makeToastActivity(.center)
        
//
        let fsq = FireStoreQueries()
//

        fsq.allUserDetail(collection: "User", controller: self) { (userArr) in
            
            
            self.arr = userArr
            print(userArr)
            
            self.view.hideToastActivity()
            self.tableView.reloadData()
        }
        
        print("her eis iuser alsdfj \(arr)")
         allUserTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil) , forCellReuseIdentifier: "FriendCell")
        allUserTableView.separatorStyle = .none

        //print("here is arr : \(arr)")
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return searchArr1.count
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
    
        let url = NSURL(string: arr[indexPath.row].ImageURL!)
        
        cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
        
        cell.senderUsername.text = arr[indexPath.row].Name
        cell.lastMessageTime.text = ""
        cell.lastMessageText.text = arr[indexPath.row].Email
         return cell
        
    }
    var conversationID = ""
    var senderUserID = ""
    var senderImageURL = ""
    var senderUserName = ""
    var receiverOnlineStatus = false
    let fs = FireStoreQueries()
    //var sendImageURL  = NSString
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        receiverUserID = arr[indexPath.row].UserID
        receiverImageURL = arr[indexPath.row].ImageURL!
        receiverUserName = arr[indexPath.row].Name
        receiverOnlineStatus = arr[indexPath.row].ISOnline
        let user = Auth.auth().currentUser
                       if let user = user {
                       
                         let uid = user.uid
                           
                        senderUserID = user.uid
                      //  sendImageURL = user.photoURL?
                        
                          
                           if uid > receiverUserID {
                               
                               conversationID = uid + receiverUserID
                               
                           }else{
                                conversationID =   receiverUserID + uid
                           }
                         
                           print(conversationID)
                        
                       }
        
      
        performSegue(withIdentifier: "allUserToChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allUserToChat" {
            
            let chatVC = segue.destination as! ChatViewController
            
            
           // chatVC.senderUserID = ""
            chatVC.conversationID = self.conversationID
            chatVC.receiverUserID = self.receiverUserID
            chatVC.receiverName = self.receiverUserName
            chatVC.receiverImageURL = self.receiverImageURL
            chatVC.senderUserID = self.senderUserID
            chatVC.senderImageURL = self.senderImageURL
            chatVC.senderUserName = self.senderUserName
            chatVC.receiverOnlineStatus = self.receiverOnlineStatus
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
