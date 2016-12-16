//
//  TimerViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/16/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var hoursPicker: UIPickerView!
    @IBOutlet weak var selectHourBtn: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var pickerUIView: UIView!
    var timeValue : Int = 0
    
    let hoursList : NSMutableArray = ["15 minutes", "30 minutes", "45 minutes","1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours", "11 hours", "12 hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        hoursPicker.delegate = self
        hoursPicker.dataSource = self
        
        pickerUIView.isHidden = true
        pickerUIView.layer.cornerRadius = 5.0
        
        if (valueOfUserDefaultAlreadyExist(key: "playTime")) {
            timeValue = Int(UserDefaults.standard.value(forKey: "playTime") as! String)!
        }
        
        hourLabel.text = hoursList[timeValue] as? String
        hoursPicker.selectRow(timeValue, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func valueOfUserDefaultAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(String(timeValue), forKey: "playTime")
        UserDefaults.standard.synchronize()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectHourBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
            self.pickerUIView.isHidden = false
        }, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hoursList.count
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hoursList[row] as? String
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.timeValue = self.hoursPicker.selectedRow(inComponent: 0)
            self.hourLabel.text = self.hoursList[self.hoursPicker.selectedRow(inComponent: 0)] as? String
            self.pickerUIView.isHidden = true
        }, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.pickerUIView.isHidden = true
        }, completion: nil)
    }
}
