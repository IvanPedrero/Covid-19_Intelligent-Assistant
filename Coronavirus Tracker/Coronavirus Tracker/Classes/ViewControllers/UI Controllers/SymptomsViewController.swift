//
//  SymptomsViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 03/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController {
    
    @IBOutlet weak var lottieAnimationView1: UIView!
    @IBOutlet weak var lottieAnimationView2: UIView!
    @IBOutlet weak var lottieAnimationView3: UIView!
    
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leastContainerView: UIView!
    @IBOutlet weak var seriousContainerView: UIView!
    @IBOutlet weak var whoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss (animated: true, completion: nil)
    }
    
    @IBAction func openWhoSymptoms(_ sender: Any) {
        Requests.openWhoSymptoms()
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
