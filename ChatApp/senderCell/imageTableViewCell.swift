//
//  imageTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 10/30/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class imageTableViewCell: UITableViewCell {


    
  
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet var senderUsername: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let m  = GeneralFunction()
        
        m.sendingImage(imageView: senderImageView)
        m.profileImage(image: avatarImageView)
 
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



