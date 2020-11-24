//
//  HomeViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 02/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import Lottie
import Charts

class HomeViewController: UIViewController {
    
    
    // MARK:- Main containers view.
    @IBOutlet weak var buttonViewContainer: UIView!
    @IBOutlet weak var newConfirmedViewContainer: UIView!
    @IBOutlet weak var totalConfirmedViewContainer: UIView!
    @IBOutlet weak var plotViewContainer: UIView!
    @IBOutlet weak var newDeathsViewContainer: UIView!
    @IBOutlet weak var newRecoveredViewContainer: UIView!
    
    // MARK:- UI labels.
    @IBOutlet weak var newConfirmedLabel: UILabel!
    @IBOutlet weak var totalConfirmedLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    @IBOutlet weak var newRecoveredLabel: UILabel!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var totalRecoveriesLabel: UILabel!
    
    // MARK:- UI special components.
    @IBOutlet weak var graphView: UIView!
    
    // MARK:- Delegates.
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var pieChartView: PieChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDelegates()
        styleContainerViews()
        getSummaryInformation()
    }
    
    // MARK:- Button actions.
    
    /// Action mapped to a button. Opens the WHO coronavirus website.
    @IBAction func openWHO(_ sender: Any) {
        Requests.openWhoWebsite()
    }
    
    
    // MARK:- UI functions.
    
    /// Sets the UI delegates for extension use.
    func setDelegates(){
        scrollView.delegate = self
    }
    
    /// Style the containers on the scrollview with corner radius and back shadows.
    func styleContainerViews(){
        buttonViewContainer.stylizeContainerView()
        newConfirmedViewContainer.stylizeContainerView()
        totalConfirmedViewContainer.stylizeContainerView()
        plotViewContainer.stylizeContainerView()
        newDeathsViewContainer.stylizeContainerView()
        newRecoveredViewContainer.stylizeContainerView()
    }
    
    /// Get the information of the summary from an API call and set the values in the UI.
    func getSummaryInformation(){
        showLoadingAnimation()
        
        Requests.getSummaryInformation(completion: { dic in
            if let dic = dic{
                /// Update GUI from request information.
                DispatchQueue.main.async {
                    self.newConfirmedLabel.text = String(format: "%@", dic["NewConfirmed"] as! CVarArg)
                    self.totalConfirmedLabel.text = String(format: "%@", dic["TotalConfirmed"] as! CVarArg)
                    self.newDeathsLabel.text = String(format: "%@", dic["NewDeaths"] as! CVarArg)
                    self.newRecoveredLabel.text = String(format: "%@", dic["NewRecovered"] as! CVarArg)
                    self.totalDeathsLabel.text = "Total deaths: " + String(format: "%@", dic["TotalDeaths"] as! CVarArg)
                    self.totalRecoveriesLabel.text = "Total recovered: " + String(format: "%@", dic["TotalRecovered"] as! CVarArg)

                        
                    let title = ["Deaths", "Recovered"]
                    let totals = [dic["TotalDeaths"], dic["TotalRecovered"]]
                    let colors:[NSUIColor] = [
                        NSUIColor(red: 133/255.0, green: 112/255.0, blue: 248/255.0, alpha: 1.0),
                        NSUIColor(red: 95/255.0, green: 204/255.0, blue: 236/255.0, alpha: 1.0)
                    ]
                    
                    var entries = [PieChartDataEntry]()
                    for (index, value) in totals.enumerated() {
                        let entry = PieChartDataEntry()
                        entry.y = value as! Double
                        entry.label = title[index]
                        entries.append(entry)
                    }
                    let set = PieChartDataSet(entries:entries)
                    set.colors = colors
                    let data = PieChartData(dataSet: set)
                    self.pieChartView.data = data
                    self.pieChartView.rotationEnabled = false
                    self.pieChartView.animate(yAxisDuration: 3)

                    self.pieChartView.noDataText = "No data available"
                    
                    self.stopLoadingAnimation()
                }
            }else{
                    print("Error")
            }
        })
        
    }
    
    
    // MARK:- Loading animation.
    func showLoadingAnimation(){
        
    }
    
    func stopLoadingAnimation(){
        
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

extension UIViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Limit top bounce.
        if scrollView.contentOffset.y <= -100 {
            scrollView.contentOffset.y = -100
        }
    }

}
