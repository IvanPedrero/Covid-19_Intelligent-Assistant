//
//  CahtbotViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 07/11/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import WebKit

class ChatbotViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://web-chat.global.assistant.watson.cloud.ibm.com/preview.html?region=us-south&integrationID=99247b21-705c-45da-8666-ad58cd66bd42&serviceInstanceID=816adb02-a55b-4e54-913f-2328eb28c7ca")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss (animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
