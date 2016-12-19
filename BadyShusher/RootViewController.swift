//
//  RootViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit
import AVFoundation

class RootViewController: UIViewController {

    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    var player: AVAudioPlayer?
    var recorder : AVAudioRecorder?
    
    var selectedSoundName : String = ""
    var appStart : Bool = false
    var isSoundPlay : Bool = false
    var soundLimits : NSMutableArray = []
    var playSoundTimer, levelTimer, stopTimer, repeatTimer : Timer!
    
    var lowPassResults : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newProductVC = self.storyboard?.instantiateViewController(withIdentifier: "newProductVC") as! NewProductViewController
        self.navigationController?.present(newProductVC, animated: true, completion: nil)
        var audioFileURL = Bundle.main.url(forResource: "shush_v2", withExtension: "mp3")
        if valueOfUserDefaultAlreadyExist(key: "selectedSound") {
            selectedSoundName = UserDefaults.standard.value(forKey: "selectedSound") as! String
        
            if selectedSoundName != "Application Default Sound" {
                var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                documentsPath = documentsPath + "/" + selectedSoundName + ".caf"
                audioFileURL = URL(fileURLWithPath: documentsPath)
            }
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioFileURL!)
            
            player?.numberOfLoops = -1
            player?.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func valueOfUserDefaultAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func playSound(volume: Float) {
        soundLimits.removeAllObjects()
        isSoundPlay = true
        if valueOfUserDefaultAlreadyExist(key: "soundEqualizer") {
            let soundEqualizer = UserDefaults.standard.bool(forKey: "soundEqualizer")
            if soundEqualizer == false && volume != 0.0 {
                playSoundTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(stopPlayer), userInfo: nil, repeats: false)
            }
        }
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.mixWithOthers)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
            try session.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        
        var audioFileURL = Bundle.main.url(forResource: "shush_v2", withExtension: "mp3")
        if valueOfUserDefaultAlreadyExist(key: "selectedSound") {
            selectedSoundName = UserDefaults.standard.value(forKey: "selectedSound") as! String
            
            if selectedSoundName != "Application Default Sound" {
                var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                documentsPath = documentsPath + "/" + selectedSoundName + ".caf"
                audioFileURL = URL(fileURLWithPath: documentsPath)
            }
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioFileURL!)
            
            player?.numberOfLoops = -1
            player?.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        
        player?.currentTime = 0.0
        player?.play()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch let error {
            print(error.localizedDescription)
        }
        
        player?.volume = volume
        
    }
    
    func stopPlayer() {
        if (playSoundTimer != nil) {
            playSoundTimer.invalidate()
            playSoundTimer = nil
        }
        isSoundPlay = false
        player?.stop()
        self.startRecording()
        levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(levelTimerCallBack), userInfo: nil, repeats: true)
        repeatTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(stopAction), userInfo: nil, repeats: false)
        
    }
    
    func startRecording() {
        if (!appStart){
            return
        }
        
        let url = URL(fileURLWithPath: "/dev/null")
        
        print("Record Path \(url.relativePath)")
        
        let recordSettings = [AVFormatIDKey:kAudioFormatAppleIMA4,
                              AVSampleRateKey:44100.0,
                              AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
                              AVLinearPCMBitDepthKey:16,
                              AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue
            
        ] as [String : Any]
        
        do {
            try recorder = AVAudioRecorder(url: url, settings: recordSettings)
            if (recorder != nil) {
                recorder?.prepareToRecord()
                recorder?.isMeteringEnabled = true
                recorder?.record(forDuration: 10)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func levelTimerCallBack() {
        recorder?.updateMeters()
        
        let ALPHA : Double = 0.05
        let peakPowerForChannel : Double = pow(10, 0.05 * Double((recorder?.peakPower(forChannel: 0))!))
        lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults
        
        var micPower = 0.0;
        SCListener.shared().listen()
        
        let instantaneousPower = SCListener.shared().peakPower()
        micPower = ALPHA * Double(instantaneousPower) + (1.0 - ALPHA) * micPower
        
        soundLimits.add(NSNumber(value: micPower))
    }
    
    func checkMicSound() {
        var micLevel : Double = 0.0
        
        if valueOfUserDefaultAlreadyExist(key: "voiceDepth") {
            let voiceDepth = UserDefaults.standard.object(forKey: "voiceDepth") as! Int
            switch voiceDepth {
            case 0:
                micLevel = 0.002351
                break
            case 1:
                micLevel = 0.01000
                break
            case 2:
                micLevel = 0.9900
                break
            case 3:
                micLevel = 0.07
                break
            default:
                break
            }
        } else {
            micLevel = 0.002351
        }
        var count : Int = 0
        
        for item in soundLimits {
            let micPower = Double(item as! NSNumber)
            if micPower > micLevel {
                count = count + 1
            }
        }
        
        if (!isSoundPlay) {
            if (soundLimits.count < count * 2){
                playSound(volume: 1.0)
            } else {
                playSound(volume: 0.2)
            }
        }
    }
    
    func stopAction() {
        SCListener.shared().stop()
        recorder?.stop()
        if levelTimer != nil {
            levelTimer.invalidate()
            levelTimer = nil
        }
        
        checkMicSound()
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        appStart = true
        playSound(volume: 0.01)
    }

    @IBAction func optionBtnPressed(_ sender: Any) {
        let optionVC = self.storyboard?.instantiateViewController(withIdentifier: "optionVC") as! OptionViewController
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.comiunityVC = optionVC;
        }
        self.navigationController?.pushViewController(optionVC, animated: true)
    }
}
