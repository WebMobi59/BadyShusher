//
//  ViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {

    @IBOutlet weak var quickStartBtn: UIButton!
    @IBOutlet weak var FAQsBtn: UIButton!
    @IBOutlet weak var timerBtn: UIButton!
    @IBOutlet weak var equalizerBtn: UIButton!
    @IBOutlet weak var customBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var appBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func quickStartBtnPressed(_ sender: Any) {
        let quickStartVC = self.storyboard?.instantiateViewController(withIdentifier: "quickStartVC") as! QuickStartViewController
        self.navigationController?.pushViewController(quickStartVC, animated: true)
    }

    @IBAction func FAQsBtnPressed(_ sender: Any) {
        let faqsVC = self.storyboard?.instantiateViewController(withIdentifier: "faqsVC") as! FAQSViewController
        self.navigationController?.pushViewController(faqsVC, animated: true)
    }
    
    @IBAction func timerBtnPressed(_ sender: Any) {
        let timerVC = self.storyboard?.instantiateViewController(withIdentifier: "timerVC") as! TimerViewController
        self.navigationController?.pushViewController(timerVC, animated: true)
    }
    
    @IBAction func equalizerBtnPressed(_ sender: Any) {
        let equalizerVC = self.storyboard?.instantiateViewController(withIdentifier: "soundEquilizerVC") as! SoundEquilizerViewController
        self.navigationController?.pushViewController(equalizerVC, animated: true)
    }
    
    @IBAction func customBtnPressed(_ sender: Any) {
        let customVC = self.storyboard?.instantiateViewController(withIdentifier: "recorderVC") as! RecorderViewController
        self.navigationController?.pushViewController(customVC, animated: true)
    }
    
    @IBAction func videoBtnPressed(_ sender: Any) {
//        let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "videoVC") as! VideoViewController
//        self.navigationController?.present(videoVC, animated: true, completion: nil)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
    }
    
    @IBAction func feedbackBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func rateBtnPressed(_ sender: Any) {
    }
    
    @IBAction func websiteBtnPressed(_ sender: Any) {
        let url = URL(string: "http://www.BabyShusher.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func appBtnPressed(_ sender: Any) {
        let url = URL(string: "https://itunes.apple.com/us/app/baby-sleep-site/id911252807?mt=8")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

