//
//  NewProductViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/15/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit

class NewProductViewController: UIViewController {

    @IBOutlet weak var continueToAppBtn: UIButton!
    @IBOutlet weak var gotoStoreBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueToAppBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoStoreBtnPressed(_ sender: Any) {
        let url = URL(string: "http://www.babyshusher.com/products.php?utm_campaign=App&utm_medium=app1&utm_source=shusherapp")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
