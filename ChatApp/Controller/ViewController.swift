//
//  ViewController.swift
//  ChatApp
//
//  Created by umer hamid on 10/29/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var lbl: PaddingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lbl.backgroundColor = UIColor.gray
        lbl.text = "hellow world"
        // Adding an out going chat bubble
        
        
        
//          var chatBubbleDataMine = ChatBubbleData(text: "Hey there!!! How are you?", image: nil, date: NSDate(), type: .Mine)
//          var chatBubbleMine = ChatBubble(data: chatBubbleDataMine, startY: 50)
//          self.view.addSubview(chatBubbleMine)
//
//          // Adding an incoming chat bubble
//          var chatBubbleDataOpponent = ChatBubbleData(text: "Fine bro!!! check this out", image:UIImage(named: "chatImage3.jpg"), date: NSDate(), type: .Opponent)
//        var chatBubbleOpponent = ChatBubble(data: chatBubbleDataOpponent, startY: chatBubbleMine.frame.maxY + 10)
        
        
        //  self.view.addSubview(chatBubbleOpponent)
    }


}

