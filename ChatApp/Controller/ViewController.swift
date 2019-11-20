//
//  ViewController.swift
//  ChatApp
//
//  Created by umer hamid on 10/29/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AudioToolbox

class ViewController: UIViewController , AVAudioPlayerDelegate  {

    
    @IBOutlet weak var recordButton: UIButton!
    var audioPlayer:AVPlayer!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    
    override func viewDidLoad() {
           super.viewDidLoad()
         
         // self.recordButton.addTarget(self, action: #selector(holdRelease), for: UIControl.Event.touchUpInside);
        
        //recordButton.setImage(UIImage(named: "play.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        let image : UIImage = UIImage(named: "avatar.png")! //?? "play"
        recordButton.setImage(image, for: .normal)
        //(UIImage(named: "play.circle"), forState: UIControl.State.normal)

       }
    var i = 0
    @IBAction func audioDidPress(_ sender: Any) {
      
        print("tound start \(i)")
        if i == 0 {
            i = 1
            recordButton.setImage(UIImage(named: "playCell.png"), for: .normal)
            //recordButton.image("play.circle")
            //AudioSe	rvicesPlayAlertSound(1519)
             self.recordAudio()
            print("audio is startding")


        }else{
            i = 0
            recordButton.setImage(UIImage(named: "pauseCell.png"), for: .normal)
            holdRelease()
            print("audio is stop")

        }
         
     }
    
    
  
    
    
    @IBAction func test(_ sender: Any) {
        print("testing is working")
    }
    @IBAction func release(_ sender: Any) {
        
        print("button is release")
    }
     func holdRelease(){
        AudioServicesPlayAlertSound(1519)
        self.audioRecorder.stop()
        do {
            print("aurdio is stop")
            let url = URL(string: self.getDirectory().appendingPathComponent("myRecording.m4a").absoluteString)
            let audioPlayer = try AVAudioPlayer(contentsOf: url!)
            let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(audioPlayer.duration))
            print("audio duration is : \(audioPlayer.duration)")


            if Int(audioPlayer.duration) > 1{

                print("audio is working properly")
                //showSendProgress()
            }
        } catch {
            assertionFailure("Failed crating audio player: \(error).")
        }
    }

  
}

extension ViewController: AVAudioRecorderDelegate{
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
       // self.audioButton.setImage(self.play, for: .normal)
    }
    
    func recordAudio(){
        let fileName = self.getDirectory().appendingPathComponent("myRecording.m4a")
        do{
            
            self.audioRecorder =  try AVAudioRecorder(url: fileName, settings: self.settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
        }catch{
           // self.showErrorAlert(message: "Recording Failed")
            print("recodring is failed")
        }
    }
    
    func setupAudioSession(){
        self.recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission({(hasPermission) in
            if hasPermission{
                print("Permission Granted")
            }
        })
    }
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}


