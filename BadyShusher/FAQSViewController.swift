//
//  FAQSViewController.swift
//  BadyShusher
//
//  Created by bluedragon on 12/16/16.
//  Copyright © 2016 mobiledeveloper. All rights reserved.
//

import UIKit

class FAQSViewController: UIViewController {

    @IBOutlet weak var faqView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let localfilePath = Bundle.main.url(forResource: "faq", withExtension: "docx")
        let myRequest = NSURLRequest(url: localfilePath!);
        faqView.loadRequest(myRequest as URLRequest);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
