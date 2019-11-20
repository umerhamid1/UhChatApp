//
//  audioSendersTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 11/18/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import AVKit
import SwiftySound

class audioSendersTableViewCell: UITableViewCell {

    var audioButton:UIButton!
    
    var play = UIImage(named: "play")
    var pause = UIImage(named: "pause")
    @IBOutlet weak var senderName: UILabel!
     
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var playButtonOutLet: UIButton!
     

    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var audioTimeBar: UIProgressView!
     
    @IBOutlet weak var audioView: UIView!
    
    var url = ""
    var tag1 = 0
    var tagArr = [Int]()
    
    var urlstring = ""

     override func awakeFromNib() {
         
        
        
         
         let image = UIImage(named : "play")
         playButtonOutLet.setImage( image, for: .normal)
         
         
     
         audioView.layer.cornerRadius = 10
         
         let m = GeneralFunction()
         m.profileImage(image: avatarImage)
        
        
         super.awakeFromNib()
         
     }
     
     
     
      var audioPlayer:AVPlayer!
     
     func playSound(soundUrl: String)
     {
         let audioSession = AVAudioSession.sharedInstance()
         do {
             
             try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
             try audioSession.setMode(AVAudioSession.Mode.spokenAudio)
             try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
             
             let currentRoute = AVAudioSession.sharedInstance().currentRoute
             for description in currentRoute.outputs {
                 if description.portType == AVAudioSession.Port.headphones {
                     try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
                 } else {
                     try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                 }
             }
             
         } catch {
             print("audioSession properties weren't set because of an error.")
         }
         let url = URL(string: soundUrl)
         let item = AVPlayerItem(url: url!)
         NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
         self.audioPlayer = AVPlayer(playerItem: item)
     }
     @objc func playerDidFinishPlaying(sender: NSNotification) {
         self.playButtonOutLet.setImage(self.play, for: .normal)
     }
     

    
    
}
