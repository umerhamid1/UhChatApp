//
//  ReceiverTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 10/29/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // let m = GeneralFunction()
         //let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let m = GeneralFunction()
        m.profileImage(image: avatarImageView)
        messageBody.layer.masksToBounds = true
        messageBody.layer.cornerRadius = 5
//
      
    
        
        
        
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

@IBDesignable class PaddingLabel1: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
