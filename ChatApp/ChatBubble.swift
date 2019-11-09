////
////  ChatBubble.swift
////  ChatApp
////
////  Created by umer hamid on 10/30/19.
////  Copyright © 2019 umer hamid. All rights reserved.
////
//
//import UIKit
//
//class ChatBubble: UIView {
//
//
//    // Properties
//    var imageViewChat: UIImageView?
//    var imageViewBG: UIImageView?
//    var text: String?
//    var labelChatText: UILabel?
//
//    /**
//    Initializes a chat bubble view
//
//    :param: data   ChatBubble Data
//    :param: startY origin.y of the chat bubble frame in parent view
//
//    :returns: Chat Bubble
//    */
//    init(data: ChatBubbleData, startY: CGFloat){
//
//        // 1. Initializing parent view with calculated frame
//        super.init(frame: ChatBubble.framePrimary(type: data.type, startY:startY))
//
//        // Making Background color as gray color
//        self.backgroundColor = UIColor.lightGray
//
//        let padding: CGFloat = 10.0
//
//        // 2. Drawing image if any
//        if let chatImage = data.image {
//
//            let width: CGFloat = min(chatImage.size.width, self.frame.width - 2 * padding)
//            let height: CGFloat = chatImage.size.height * (width / chatImage.size.width)
//            imageViewChat = UIImageView(frame: CGRect(x: padding, y: padding, width: width, height: height))
//            imageViewChat?.image = chatImage
//            imageViewChat?.layer.cornerRadius = 5.0
//            imageViewChat?.layer.masksToBounds = true
//            self.addSubview(imageViewChat!)
//
//        }
//
//        // 3. Going to add Text if any
//        if let chatText = data.text {
//            // frame calculation
//            var startX = padding
//            var startY:CGFloat = 5.0
//            if let imageView = imageViewChat {
//                startY += imageViewChat!.frame.maxY
//            }
//            labelChatText = UILabel(frame: CGRect(x: startX, y: startY, width: self.frame.width - 2 * startX , height: 5))
//            labelChatText?.textAlignment = data.type == .Mine ? .right : .left
//            labelChatText?.font = UIFont.systemFont(ofSize: 14)
//            labelChatText?.numberOfLines = 0 // Making it multiline
//            labelChatText?.text = data.text
//            labelChatText?.sizeToFit() // Getting fullsize of it
//
//
//
//            self.addSubview(labelChatText!)
//        }
//        // 4. Calculation of new width and height of the chat bubble view
//        var viewHeight: CGFloat = 0.0
//        var viewWidth: CGFloat = 0.0
//        if let imageView = imageViewChat {
//            // Height calculation of the parent view depending upon the image view and text label
//            viewWidth = max(imageViewChat!.frame.maxX, labelChatText!.frame.maxX) + padding
//            viewHeight = max(imageViewChat!.frame.maxY, labelChatText!.frame.maxY) + padding
//
//        } else {
//            viewHeight = labelChatText!.frame.maxY + padding/2
//            viewWidth = labelChatText!.frame.width + labelChatText!.frame.minX + padding
//        }
//
//        // 5. Adding new width and height of the chat bubble frame
//        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: viewWidth, height: viewHeight)
//    }
//
//    // 6. View persistance support
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    //MARK: - FRAME CALCULATION
//    class func framePrimary(type:BubbleDataType, startY: CGFloat) -> CGRect{
//
//        let screenSize = UIScreen.main.bounds
//        let paddingFactor: CGFloat = 0.02
//        let sidePadding = screenSize.width * paddingFactor
//        let maxWidth = screenSize.width * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
//        let startX: CGFloat = type == .Mine ? screenSize.width * (CGFloat(1.0) - paddingFactor) - maxWidth : sidePadding
//        return CGRect(x: startX, y: startY, width: maxWidth, height: 5) // 5 is the primary height before drawing starts
//    }
//
//}
