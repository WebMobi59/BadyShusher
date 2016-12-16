//
//  SoundEquilizerViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit

class SoundEquilizerViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var soundToggle: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        if (valueOfUserDefaultAlreadyExist(key: "soundEqualizer")) {
            let on = UserDefaults.standard.bool(forKey: "soundEqualizer")
            soundToggle.setOn(on, animated: true)
        }
    }
    
    func valueOfUserDefaultAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(self.soundToggle.isOn, forKey: "soundEqualizer")
        UserDefaults.standard.synchronize()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func soundToggleTapped(_ sender: Any) {
    }
}
