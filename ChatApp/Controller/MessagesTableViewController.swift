//
//  MessagesTableViewController.swift
//  ChatApp
//
//  Created by umer hamid on 10/29/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {

    

    @IBOutlet var messageDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageDetails.estimatedRowHeight = 600.0
        messageDetails.rowHeight = UITableView.automaticDimension
        
        //messageDetails.rowHeight = UITableView.automaticDimension
        messageDetails.dataSource = self
        messageDetails.delegate = self
        
        messageDetails.register(UINib(nibName: "AudioTableViewCell", bundle: nil) , forCellReuseIdentifier: "audioCell")
        
    
        
       // messageTableView.register

      

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath) as! AudioTableViewCell
        
        
     //
        //cell.audioView.backgroundColor = UIColor.green
               
//
//        cell.avatarImageView.backgroundColor = UIColor.yellow
//        cell.senderUsername.text = "umer hamid"
//        cell.lastMessageText.text = "bye aldkfasjlf kjasldf;aksjd laskfjasldfkajsd;fla"
//        cell.lastMessageTime.text = " 11/11/2013 5:00 p.m"
 
        
     

                
//        tableView.rowHeight = UITableView.automaticDimension
    
        //cell.messageBody.text = ";ldflk"
     
//        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        cell.avatarImageView.layer.borderColor = UIColor.white.cgColor
//        cell.avatarImageView.layer.cornerRadius = image.frame.size.width / 3.7
//        cell.avatarImageView.clipsToBounds = true
       
        return cell
               
           
       }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 5
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    
    
}
