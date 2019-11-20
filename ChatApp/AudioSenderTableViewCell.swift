//
//  AudioSenderTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 11/18/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class AudioSenderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var senderName: UILabel!
      
      @IBOutlet weak var avatarImage: UIImageView!
      
      @IBOutlet weak var playButtonOutLet: UIButton!
      
      @IBOutlet weak var audioTimeBar: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
