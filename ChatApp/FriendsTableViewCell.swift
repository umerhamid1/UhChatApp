//
//  FriendsTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 10/31/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var lastMessageTime: UILabel!

    @IBOutlet weak var senderUsername: UILabel!
    
    
    @IBOutlet weak var lastMessageText: UILabel!
    
    
    @IBOutlet weak var isOnline: UILabel!
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //avatarImageView.image = UIImage(named : "profile11111111111")
        let m = GeneralFunction()
        m.profileImage(image: avatarImageView)
        isOnline.layer.masksToBounds = true
        isOnline.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
