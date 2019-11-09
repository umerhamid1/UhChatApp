//
//  senderTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 10/29/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class senderTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: PaddingLabel!
    @IBOutlet var senderUsername: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gf = GeneralFunction()
        gf.profileImage(image: avatarImageView)
        messageBody.layer.masksToBounds = true
        messageBody.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}




import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 500.0
    @IBInspectable var bottomInset: CGFloat = 500.0
    @IBInspectable var leftInset: CGFloat = 1600.0
    @IBInspectable var rightInset: CGFloat = 1600.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
