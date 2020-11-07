//
//  QuestionnaireViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 06/11/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import iOSDropDown
import CoreML
import Vision

class QuestionnaireViewController: UIViewController {

    @IBOutlet weak var ageDropDown: DropDown!
    @IBOutlet weak var anemiaDropDown: DropDown!
    @IBOutlet weak var diabetesDropDown: DropDown!
    @IBOutlet weak var highBloodDropDown: DropDown!
    @IBOutlet weak var sexDropDown: DropDown!
    @IBOutlet weak var smokingDropDown: DropDown!
    
    var ageData:[String] = ["10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"]
    var sexData:[String] = ["Male", "Female"]
    var binaryData:[String] = ["Yes", "No"]
    
    fileprivate var LOW_RISK_MESSAGE = "You have low risk of getting seriously sick, stay home and prevent other people of getting sick"
    fileprivate var MEDIUM_RISK_MESSAGE = "You have medium risk of getting seriously sick, stay safe and do not go out unless necessary"
    fileprivate var HIGH_RISK_MESSAGE = "You have high risk of getting seriously sick, do not leave your home and protect yourself using masks and sanitizers"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // The list of array to display. Can be changed dynamically
        ageDropDown.optionArray = ageData
        ageDropDown.selectedRowColor = .white
        
        anemiaDropDown.optionArray = binaryData
        anemiaDropDown.selectedRowColor = .white
        
        diabetesDropDown.optionArray = binaryData
        diabetesDropDown.selectedRowColor = .white
        
        highBloodDropDown.optionArray = binaryData
        highBloodDropDown.selectedRowColor = .white
        
        sexDropDown.optionArray = sexData
        sexDropDown.selectedRowColor = .white
    
        smokingDropDown.optionArray = binaryData
        smokingDropDown.selectedRowColor = .white
        
        // The the Closure returns Selected Index and String
        /*ageDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
        }*/
    }
    
    
    @IBAction func sendQuestionnaire(_ sender: Any) {
        
        if ageDropDown.selectedIndex == nil || anemiaDropDown.selectedIndex == nil || diabetesDropDown.selectedIndex == nil || highBloodDropDown.selectedIndex == nil || sexDropDown.selectedIndex == nil || smokingDropDown.selectedIndex == nil {
            return
        }
        
        var age:String = ageDropDown.optionArray[ageDropDown.selectedIndex!]
        
        var anemia:Int = 0
        if let anemiaString:String = anemiaDropDown.optionArray[anemiaDropDown.selectedIndex!] {
            if anemiaString == "Yes" {
                anemia = 1
            }
            else if anemiaString == "No" {
                anemia = 0
            }
        }
        
        var diabetes:Int = 0
        if let diabetesString:String = diabetesDropDown.optionArray[diabetesDropDown.selectedIndex!]{
            if diabetesString == "Yes" {
                diabetes = 1
            }
            else if diabetesString == "No" {
                diabetes = 0
            }
        }
        
        var highBlood:Int = 0
        if let highBloodString:String = highBloodDropDown.optionArray[highBloodDropDown.selectedIndex!]{
            if highBloodString == "Yes" {
                highBlood = 1
            }
            else if highBloodString == "No" {
                highBlood = 0
            }
        }
        
        var sex:Int = 0
        if let sexString:String = sexDropDown.optionArray[sexDropDown.selectedIndex!]{
            if sexString == "Male" {
                sex = 1
            }
            else if sexString == "Female" {
                sex = 0
            }
        }
        
        var smoking:Int = 0
        if let smokingString:String = smokingDropDown.optionArray[smokingDropDown.selectedIndex!]{
            if smokingString == "Yes" {
                smoking = 1
            }
            else if smokingString == "No" {
                smoking = 0
            }
        }
        
        let dict: NSDictionary = [
            "age": age,
            "anemia": anemia,
            "diabetes": diabetes,
            "highBlood": highBlood,
            "sex": sex,
            "smoking": smoking
        ]
        
        predictData(dict: dict)
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss (animated: true, completion: nil)
    }
    
    
    // MARK: - CoreML Methods
    
    func predictData(dict:NSDictionary) {
        
        // Generate the request.
        let model = CovidMortalityRegression()
        
        if let prediction = try? model.prediction(age: dict["age"] as! String, anaemia: dict["anemia"] as! Double, diabetes: dict["diabetes"] as! Double, high_blood_pressure: dict["highBlood"] as! Double, sex: dict["sex"] as! Double, smoking: dict["smoking"] as! Double) {
            
            var percentage:Double = (prediction.COVID_PERCENTAGE*100).rounded(toPlaces: 2)
            
            var correspondingMessage:String = ""
            if percentage >= 0.2 && percentage < 2.0 {
                correspondingMessage = LOW_RISK_MESSAGE
            }
            else if percentage >= 2.0 && percentage < 8.0 {
                correspondingMessage = MEDIUM_RISK_MESSAGE
            }
            else if percentage >= 8.0{
                correspondingMessage = HIGH_RISK_MESSAGE
            }
            
            showAlert(percentage: percentage, message: correspondingMessage)
        }
    }
    
    func showAlert(percentage:Double, message: String){
        let alert = UIAlertController(title: "Risk probability: \(percentage)", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "More info", style: .default, handler: { action in
            Requests.openWhoWebsite()
        }))

        self.present(alert, animated: true)

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

// MARK: - Extensions

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
