//
//  RecordDetailViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit
import AVFoundation

class RecordDetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var setasDefaultBtn: UIButton!
    
    var filename : String!
    var isPlay : Bool!
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (filename == "Application Default Sound") {
            deleteBtn.isEnabled = false
        }
        
        isPlay = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        if (isPlay == true) {
            if (audioPlayer.isPlaying){
                audioPlayer.stop()
            }
            isPlay = false
            playBtn.setBackgroundImage(UIImage(named: "play"), for: .normal)
        } else {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.mixWithOthers)
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
                try audioSession.setActive(true)
            } catch let error {
                print(error.localizedDescription)
            }
            var audioFileURL = Bundle.main.url(forResource: "shush_v2", withExtension: "mp3")
            if (filename != "Application Default Sound") {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let docsDirect = paths[0]
                audioFileURL = docsDirect.appendingPathComponent(filename + ".caf")
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL!)
                
                audioPlayer?.prepareToPlay()
            } catch let error {
                print(error.localizedDescription)
            }
            
            audioPlayer?.play()
            isPlay = true
            self.playBtn.setBackgroundImage(UIImage(named: "stop"), for: .normal)
            
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func valueOfUserDefaultAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        var tmp : NSArray = []
        if (valueOfUserDefaultAlreadyExist(key: "sounds")) {
            tmp = UserDefaults.standard.array(forKey:"sounds") as NSArray!
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let deleteFileURL = docsDirect.appendingPathComponent(filename + ".caf")
        
        do {
            try FileManager.default.removeItem(at: deleteFileURL)
        } catch let error {
            let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
            })
            
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        let array : NSMutableArray = NSMutableArray(array: tmp)
        array.remove(filename)
        UserDefaults.standard.set(array, forKey: "sounds")
        UserDefaults.standard.synchronize()
        let alertVC = UIAlertController(title: "Done", message: "File deleted", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
        })
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func setasDefaultBtnPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Done", message: "Set as default audio", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            UserDefaults.standard.set(self.filename, forKey: "selectedSound")
            UserDefaults.standard.synchronize()
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
