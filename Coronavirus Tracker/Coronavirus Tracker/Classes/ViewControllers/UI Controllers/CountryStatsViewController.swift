//
//  CountryStatsViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 03/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import Lottie
import Charts

class CountryInformation {
    var country: String?
    var countryCode: String?
    var slug: String?
    var newConfirmed: Double?
    var totalConfirmed: Double?
    var newDeaths: Double?
    var totalDeaths: Double?
    var newRecovered: Double?
    var totalRecovered: Double?
    var date: String?
    
    init(country:String, countryCode:String, slug:String, newConfirmed:Double, totalConfirmed:Double, newDeaths:Double, totalDeaths: Double, newRecovered: Double, totalRecovered: Double, date:String) {
        self.country = country
        self.countryCode = countryCode
        self.slug = slug
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.totalRecovered = totalRecovered
        self.date = date
    }
}

class CountryStatsViewController: UIViewController {

    @IBOutlet weak var countrySelectorTextField: UITextField!
    
    // MARK:- Country data.
    var selectedCountry:CountryInformation?
    var listOfCountries = [CountryInformation]()
        
    // MARK:- UI main interfaces.
    @IBOutlet weak var enabledView: UIView!
    @IBOutlet weak var hiddenView: UIView!
    
    // MARK:- UI labels and chart views.
    @IBOutlet weak var newConfirmedLabel: UILabel!
    @IBOutlet weak var totalConfirmedLabel: UILabel!
    @IBOutlet weak var barChartView: PieChartView!
    @IBOutlet weak var newRecoveredLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    
    // MARK:- UI view containers and buttons.
    @IBOutlet weak var newConfirmedContainerView: UIView!
    @IBOutlet weak var totalConfirmedContainerView: UIView!
    @IBOutlet weak var plotContainerView: UIView!
    @IBOutlet weak var newDeathContainerView: UIView!
    @IBOutlet weak var newRecoveredContainerView: UIView!
    @IBOutlet weak var returnButton: UIButton!
    
    
    @IBOutlet weak var animationContainerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleContainerViews()
        getCountryInformation()
    }
    
    func styleContainerViews(){
        countrySelectorTextField.layer.shadowColor = UIColor.black.cgColor
        countrySelectorTextField.layer.shadowOpacity = 0.2
        countrySelectorTextField.layer.shadowOffset = .zero
        countrySelectorTextField.layer.shadowRadius = 6
        
        newConfirmedContainerView.layer.cornerRadius = 10
        newConfirmedContainerView.layer.shadowColor = UIColor.black.cgColor
        newConfirmedContainerView.layer.shadowOpacity = 0.2
        newConfirmedContainerView.layer.shadowOffset = .zero
        newConfirmedContainerView.layer.shadowRadius = 10
        
        totalConfirmedContainerView.layer.cornerRadius = 10
        totalConfirmedContainerView.layer.shadowColor = UIColor.black.cgColor
        totalConfirmedContainerView.layer.shadowOpacity = 0.2
        totalConfirmedContainerView.layer.shadowOffset = .zero
        totalConfirmedContainerView.layer.shadowRadius = 10
        
        plotContainerView.layer.cornerRadius = 10
        plotContainerView.layer.shadowColor = UIColor.black.cgColor
        plotContainerView.layer.shadowOpacity = 0.2
        plotContainerView.layer.shadowOffset = .zero
        plotContainerView.layer.shadowRadius = 10
        
        newDeathContainerView.layer.cornerRadius = 10
        newDeathContainerView.layer.shadowColor = UIColor.black.cgColor
        newDeathContainerView.layer.shadowOpacity = 0.2
        newDeathContainerView.layer.shadowOffset = .zero
        newDeathContainerView.layer.shadowRadius = 10
        
        newRecoveredContainerView.layer.cornerRadius = 10
        newRecoveredContainerView.layer.shadowColor = UIColor.black.cgColor
        newRecoveredContainerView.layer.shadowOpacity = 0.2
        newRecoveredContainerView.layer.shadowOffset = .zero
        newRecoveredContainerView.layer.shadowRadius = 10
        
        returnButton.layer.cornerRadius = 8
        returnButton.layer.shadowColor = UIColor.black.cgColor
        returnButton.layer.shadowOpacity = 0.2
        returnButton.layer.shadowOffset = .zero
        returnButton.layer.shadowRadius = 5
    }
    
    /// Get the information of the summary from an API call and set the values in the UI.
    func getCountryInformation(){
        
        hideInformationView()
        
        Requests.getCountryInformation(completion: { dic in
            if let dic = dic{
                for country in dic{
                    
                    self.listOfCountries.append(
                        CountryInformation(country: country["Country"] as! String,
                                           countryCode: country["CountryCode"] as! String,
                                           slug: country["Slug"] as! String,
                                           newConfirmed: country["NewConfirmed"] as! Double,
                                           totalConfirmed: country["TotalConfirmed"] as! Double,
                                           newDeaths: country["NewDeaths"] as! Double,
                                           totalDeaths: country["TotalDeaths"] as! Double,
                                           newRecovered: country["NewRecovered"] as! Double,
                                           totalRecovered: country["TotalRecovered"] as! Double,
                                           date: country["Date"] as! String)
                    )
                    
                }
                self.createAndSetupPicker()
                self.dismissAndClosePickerView()
                
            }else{
                print("Error")
            }
        })
        
    }
    
    /// This function will set the fetched data on the view from the request.
    func setDataOnView(){
        DispatchQueue.main.async {
            
            // Avoid errors on the text label.
            if self.countrySelectorTextField.text == "" {
                self.countrySelectorTextField.text = self.selectedCountry?.country
            }
            
            self.newConfirmedLabel.text = "\( self.selectedCountry?.newConfirmed?.roundToInt() ?? 0)"
            self.totalConfirmedLabel.text = "\( self.selectedCountry?.totalConfirmed?.roundToInt() ?? 0)"
            self.newRecoveredLabel.text = "\( self.selectedCountry?.newRecovered?.roundToInt() ?? 0)"
            self.newDeathsLabel.text = "\( self.selectedCountry?.newDeaths?.roundToInt() ?? 0)"
            
            let title = ["Total Deaths", "Total Recovered"]
            let totals = [self.selectedCountry?.totalDeaths, self.selectedCountry?.totalRecovered]
            let colors:[NSUIColor] = [
                NSUIColor(red: 133/255.0, green: 112/255.0, blue: 248/255.0, alpha: 1.0),
                NSUIColor(red: 95/255.0, green: 204/255.0, blue: 236/255.0, alpha: 1.0)
            ]
            
            var entries = [PieChartDataEntry]()
            for (index, value) in totals.enumerated() {
                let entry = PieChartDataEntry()
                entry.y = value!
                entry.label = title[index]
                entries.append(entry)
            }
            let set = PieChartDataSet(entries:entries)
            set.colors = colors
            let data = PieChartData(dataSet: set)
            self.barChartView.data = data
            self.barChartView.rotationEnabled = false
            self.barChartView.drawEntryLabelsEnabled = false
            self.barChartView.animate(yAxisDuration: 2)

            self.barChartView.noDataText = "No data available"
            
        }
        
        if self.selectedCountry != nil {
            self.enableInformationView()
        }
        else{
            self.hideInformationView()
        }
    }
    
    /// Creates the picker view object and the delegates. Assign the data input of the text field from the picker view.
    func createAndSetupPicker(){
        DispatchQueue.main.async {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            self.countrySelectorTextField.inputView = pickerView
        }
    }
    
    /// Adds a toolbar for the picker view and sets the select country button.
    func dismissAndClosePickerView(){
        DispatchQueue.main.async {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            
            let button = UIBarButtonItem(title: "Select country", style: .plain, target: self, action: #selector(self.dismissAction))
            button.tintColor = UIColor(displayP3Red: 133/255, green: 112/255, blue: 248/255, alpha: 1.0)
            toolBar.setItems([button], animated: true)
            self.countrySelectorTextField.inputAccessoryView = toolBar
        }
    }
    
    /// Turns on the view containing the information and graphs.
    func enableInformationView(){
        UIView.animate(withDuration: 0.4, animations: {
             self.hiddenView.alpha = 0
        }, completion:  {
           (value: Bool) in
            self.hiddenView.isHidden = true
            self.enabledView.isHidden = false
            
        })
        
        self.enabledView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
                 self.enabledView.alpha = 1
            }, completion:  nil)
        
        //hiddenView.isHidden = true
        //enabledView.isHidden = false
    }
    
    /// Turns on the animation view while no country information is selected.
    func hideInformationView(){
        
        startMapAnimation()
        
        hiddenView.isHidden = false
        enabledView.isHidden = true
    }
    
    /// Creates and starts the map animation on the screen for the no-country-selected state.
    func startMapAnimation() {
      
        var animationView = AnimationView()
      
        animationView = .init(name: "map")
        animationView.frame = animationContainerView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.2
        animationContainerView.addSubview(animationView)
        
        animationView.play()
    }
    
    /// Action mapped to the select country button. Dismisses the picker view and sets the data selected on the screen.
    @objc func dismissAction(){
        if selectedCountry != nil {
            self.view.endEditing(true)
            setDataOnView()
        }
    }
    
    /// Closes the country stats view.
    @IBAction func returnAction(_ sender: Any) {
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

extension CountryStatsViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listOfCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listOfCountries[row].country
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = self.listOfCountries[row]
        self.countrySelectorTextField.text = self.selectedCountry?.country
    }
    
}

extension Double {
    func roundToInt() -> Int{
        return Int(Darwin.round(self))
    }
}
