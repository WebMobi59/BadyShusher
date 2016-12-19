//
//  RecordListViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit

class RecordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    
    var array : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var tmp : NSArray = []
        if (valueOfUserDefaultAlreadyExist(key: "sounds")) {
            tmp = UserDefaults.standard.array(forKey:"sounds") as NSArray!
        }
        array = NSMutableArray(array: tmp)
        array.add("Application Default Sound")
        _tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func valueOfUserDefaultAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        if (_tableView.isEditing) {
            self.editBtn.setTitle("Edit", for: .normal)
            _tableView.setEditing(false, animated: true)
        } else {
            self.editBtn.setTitle("Done", for: .normal)
            _tableView.setEditing(true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RecordTableViewCell
            
        cell.fileTitleLabel.text = array[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "recordDetailVC") as! RecordDetailViewController
        recordDetailVC.filename = array[indexPath.row] as! String
        self.navigationController?.pushViewController(recordDetailVC, animated: true)
    }
}
