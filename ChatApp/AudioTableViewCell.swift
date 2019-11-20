//
//  AudioTableViewCell.swift
//  ChatApp
//
//  Created by umer hamid on 10/31/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import AVKit
import SwiftySound
class AudioTableViewCell: UITableViewCell {

   
    var play = UIImage(named: "play")
    var pause = UIImage(named: "pause")
    @IBOutlet weak var senderName: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var playButtonOutLet: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var audioTimeBar: UIProgressView!
    
    @IBOutlet weak var audioView: UIView!
    
    @IBOutlet weak var status: UILabel!
    
    
    var urlstring = ""

       //print("the url = \(url!)")
      // downloadFileFromURL(url!)
      
    override func awakeFromNib() {
        
       
       
        
        let image = UIImage(named : "play")
        playButtonOutLet.setImage( image, for: .normal)
        
        
        mainView.layer.cornerRadius = 0
        audioView.layer.cornerRadius = 10
        
        let m = GeneralFunction()
        m.profileImage(image: avatarImage)
       
       // avatarImage.backgroundColor = UIColor.black
        super.awakeFromNib()
        // Initialization code
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
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
//
        var player: AVPlayer!

         urlstring = ""
      
        

        if self.playButtonOutLet.currentImage == UIImage(named: "play") {
                  //switch to image-two
            
            let image = UIImage(named : "pause")
            
    
                
              
                
                //let mySound = Sound(url: url1)
                playButtonOutLet.setImage( image, for: .normal)
                print("play")
            //playSound(soundUrl: "https://firebasestorage.googleapis.com/v0/b/chat-app-f2466.appspot.com/o/audio%2FB5CCE00B-6A41-4F8D-86B2-9C9EF03A78CAcoZlzRluENh5SAvsFBT9tSpbKlD2?alt=media&token=5e93c452-a132-4bc6-8f30-39b78e955af8")
          //  audioPlayer.play()

            Sound.play(url: "https://firebasestorage.googleapis.com/v0/b/chat-app-f2466.appspot.com/o/audio%2FB5CCE00B-6A41-4F8D-86B2-9C9EF03A78CAcoZlzRluENh5SAvsFBT9tSpbKlD2?alt=media&token=5e93c452-a132-4bc6-8f30-39b78e955af8" as! URL)
            Sound.enabled = true
            
            Sound.category = .ambient


          
            
            }
        else {
            print("pause")
          audioPlayer.pause()
            let image = UIImage(named : "play")
            playButtonOutLet.setImage( image, for: .normal)
            
            
           //switch to image-one
               }
    }
    
    var soundPlayer : AVAudioPlayer!
    var uniqueID : String?
    var isPlaying : Bool = false
    var pauseTime : Double? = 0
    var dateAndTime : String?
    var dateOnly : String?
    var timeOnly : String?
    var convoID : String?
    var audioMsgUrl : String?
    
  
    func playAudio()
    {
        let path = URL(fileURLWithPath: "firebasestorage.googleapis.com/v0/b/chat-app-f2466.appspot.com/o/audio%2FB5CCE00B-6A41-4F8D-86B2-9C9EF03A78CAcoZlzRluENh5SAvsFBT9tSpbKlD2?alt=media&token=5e93c452-a132-4bc6-8f30-39b78e955af8") ///chat.getDocumentsDirectory().appendingPathComponent("\(uniqueID!).m4a")
       /// print(uniqueID!)
        
        do
        {
            soundPlayer = try AVAudioPlayer(contentsOf: path)
            isPlaying = !isPlaying
            togglePlaying()
            getDuration(time: soundPlayer.duration)
        }
        catch
        {
            print("Doesnt ExisT : \(error)")
        }
    }
    
     func getDuration(time:Double) -> String
        {
            if soundPlayer.duration > 60
            {
                let minutes = Int(soundPlayer.duration / 60)
                let seconds = soundPlayer.duration.remainder(dividingBy: 60)
                
                print(minutes)
                print(Int(seconds))
                
                let time = "\(minutes):\(Int(seconds))"
                if minutes < 10
                {
                    //durationLbl.text = "0\(time)"
                }
                else
                {
                   // durationLbl.text = time
                }
                return time
            }
            else
            {
                if soundPlayer.duration < 10
                {
                   // durationLbl.text = "00:0\(Int(soundPlayer.duration))"
                }
                else
                {
                  //  durationLbl.text = "00:\(Int(soundPlayer.duration))"
                }
                return "00:\(Int(soundPlayer.duration))"
            }
    //        return String(duration)
        }
    
    func togglePlaying()
    {
        if isPlaying == true
        {
            soundPlayer.play()
            setAudioProgress()
            
            playButtonOutLet.setImage(UIImage(named: "pause1"), for: .normal)
        }
        else
        {
            pauseTime = Double(audioTimeBar.progress) * soundPlayer.duration
            soundPlayer.pause()
            
            setAudioProgress()
            playButtonOutLet.setImage(UIImage(named: "play1"), for: .normal)
        }
    }
    
    
    func setAudioProgress()
       {
           Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioProgress), userInfo: nil, repeats: true)
           
       }
       
       @objc func updateAudioProgress()
       {
           if soundPlayer.isPlaying
           {
               audioTimeBar.setProgress(Float(soundPlayer.currentTime/soundPlayer.duration), animated: true)
               
               print(soundPlayer.currentTime)
               
               if (soundPlayer.currentTime + 0.1) > soundPlayer.duration
               {
                   audioTimeBar.progress = 0
                   playButtonOutLet.setImage(UIImage(named: "play1"), for: .normal)
                   isPlaying = !isPlaying
                   pauseTime = 0.0
                   soundPlayer.stop()
               }
           }
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
