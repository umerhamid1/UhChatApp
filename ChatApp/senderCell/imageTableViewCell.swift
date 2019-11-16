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
        
        senderImageView.makeRoundCorners(byRadius: 10)
        m.sendingImage(imageView: senderImageView)
        m.profileImage(image: avatarImageView)
 
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension UIImageView {
   func makeRoundCorners(byRadius rad: CGFloat) {
      self.layer.cornerRadius = rad
      self.clipsToBounds = true
   }
}



@IBDesignable
class RoundUIView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
