//
//  AudioTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 10/31/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var playButtonOutLet: UIButton!
    
    override func awakeFromNib() {
        
    
        let m = GeneralFunction()
        m.profileImage(image: avatarImage)
       
        avatarImage.backgroundColor = UIColor.black
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
//
        
        

        if self.playButtonOutLet.currentImage == UIImage(named: "play.fill") {
                  //switch to image-two
            let image = UIImage(named : "pause.fill")
            playButtonOutLet.setImage( image, for: .normal)
            print("play")
            
            }
        else {
            print("pause")
            let image = UIImage(named : "play.fill")
            playButtonOutLet.setImage( image, for: .normal)
            
            
           //switch to image-one
               }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
