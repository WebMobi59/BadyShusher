//
//  ViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MessageUI
import Social

class OptionViewController: UIViewController, MFMailComposeViewControllerDelegate {

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
    
    let App_ID = 419606496
    
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
        guard let path = Bundle.main.path(forResource: "babyshusher_comp", ofType:"mp4") else {
            debugPrint("babyshusher_comp.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func sendMail() {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Check out this cool Baby App")
        mailComposerVC.setMessageBody("Hey, I thought you'd be interested in the Baby Shusher App. It is truly a Sleep Miracle for babies and has a lot of cool features, like a Timer Option, a Sound Equalizer, and the option to Custom Record your own Shush. <br/><br/>Check out how it works at www.BabyShusher.com<br/> and go get it right now.", isHTML: true)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func shareTwitter() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func shareFacebook() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Share Baby Shusher via :", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let fbAction = UIAlertAction(title: "Facebook", style: .destructive, handler: {
            (action : UIAlertAction!) -> Void in
            self.shareFacebook()
        })
        
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.sendMail()
        })
        
        let twitterAction = UIAlertAction(title: "Twitter", style: .destructive, handler: {
            (action : UIAlertAction!) -> Void in
            self.shareTwitter()
            
        })
        
        alertVC.addAction(emailAction)
        alertVC.addAction(fbAction)
        alertVC.addAction(twitterAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["Feedback@BabyShusher.com"])
        mailComposerVC.setSubject("Feedback for Baby Shusher")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertVC = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func feedbackBtnPressed(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func rateBtnPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Rate Baby Shusher", message: "If you enjoy using Baby Shusher, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Rate Baby Shusher", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
            let reviewURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + String(self.App_ID)
            let url = URL(string: reviewURL)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        })
        let cancelAction = UIAlertAction(title: "No, Thanks", style: .default, handler: nil)
        let reminderAction = UIAlertAction(title: "Remind me later", style: .default, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        alertVC.addAction(reminderAction)
        self.present(alertVC, animated: true, completion: nil)

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

