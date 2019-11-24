//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by umer hamid on 11/24/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goWelcomeToFriendList", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goWelcomeToFriendList" {
            let friendVC = segue.destination as! FriendsTableViewController
            friendVC.currentUserID = Auth.auth().currentUser?.uid
            emailG = (Auth.auth().currentUser?.email)!
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

}
