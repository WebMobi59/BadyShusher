//
//  RecorderViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var recordStopBtn: UIButton!
    var nameTextField : UITextField!
    
    var isRecording : Bool = false
    var recorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recordStopBtn.setBackgroundImage(UIImage(named:"recordBtn"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordStopBtnPressed(_ sender: Any) {
        if (isRecording) {
            self.stopRecording()
            self.recordStopBtn.setBackgroundImage(UIImage(named: "recordBtn"), for: .normal)
        } else {
            let alertVC = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Start", style: .default, handler: {
                alert -> Void in
                self.startRecording()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            alertVC.addTextField(configurationHandler: configurationTextField)
            
            alertVC.addAction(saveAction)
            alertVC.addAction(cancelAction)
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func moreBtnPressed(_ sender: Any) {
        let recordListVC = self.storyboard?.instantiateViewController(withIdentifier: "recordListVC") as! RecordListViewController
        self.navigationController?.pushViewController(recordListVC, animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func valueOfUserDefaultAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func startRecording() {
        recordStopBtn.setBackgroundImage(UIImage(named: "recordStopBtn"), for: .normal)
        isRecording = true
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.mixWithOthers)
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
            try audioSession.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        
        var tmp : NSArray = []
        if (valueOfUserDefaultAlreadyExist(key: "sounds")) {
            tmp = UserDefaults.standard.array(forKey:"sounds") as NSArray!
        }
        let array : NSMutableArray = NSMutableArray(array: tmp)
        array.add(self.nameTextField.text!)
        UserDefaults.standard.set(array, forKey: "sounds")
        UserDefaults.standard.synchronize()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        
        let url = docsDirect.appendingPathComponent(self.nameTextField.text! + ".caf")
        
//        let url = URL(fileURLWithPath: self.nameTextField.text! + ".caf")
        
        let recordSettings = [AVFormatIDKey:kAudioFormatAppleIMA4,
                              AVSampleRateKey:44100.0,
                              AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
                              AVLinearPCMBitDepthKey:16,
                              AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue,
                              AVLinearPCMIsBigEndianKey: false,
                              AVLinearPCMIsFloatKey: false
            
            ] as [String : Any]
        
        
        
        do {
            try recorder = AVAudioRecorder(url: url, settings: recordSettings)
            if (recorder != nil) {
                recorder?.prepareToRecord()
                recorder?.isMeteringEnabled = true
                recorder?.record(forDuration: 10)
            } else {
                
            }
        } catch let error {
            let alertVC = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (ok) in
                
            })
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        let audioHWAvailable = audioSession.isInputAvailable
        if (!audioHWAvailable) {
            let alertVC = UIAlertController(title: "Warning", message: "Audio input hardware not available", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (ok) in
                
            })
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
    }
    
    func stopRecording() {
        isRecording = false
        if (recorder.isRecording) {
            recorder.stop()
        }
    }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "File Name"
        nameTextField = textField
    }
}
