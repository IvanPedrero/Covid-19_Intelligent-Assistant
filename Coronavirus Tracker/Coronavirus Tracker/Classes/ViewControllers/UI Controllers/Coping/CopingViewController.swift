//
//  CopingViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 04/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit

struct Tip{
    var title:String?
    var tip:String?
    var whoLink:String?
}

class CopingViewController: UIViewController {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let tips = [
        Tip(title: "Pause. Breathe. Reflect.", tip: "Take some slow breaths: in through your nose, then slowly breathe out.", whoLink: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjKvsDD2ILrAhUKjq0KHf91ARYQ5KcGMAt6BAgFEAc&url=https%3A%2F%2Fwww.who.int%2Fpublications%2Fi%2Fitem%2F9789240003927&usg=AOvVaw2jUlMINAF_ihq3-rZMSbe1"),
        Tip(title: "Connect with others", tip: "Talking to people you trust can help. Keep in regular contact with people close to you.", whoLink: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjKvsDD2ILrAhUKjq0KHf91ARYQ5KcGMAt6BAgFEAs&url=https%3A%2F%2Fwww.who.int%2Fnews-room%2Ffeature-stories%2Fmental-well-being-resources-for-the-public&usg=AOvVaw3OCPWLvbJ-UPBt9E0u-wau"),
        Tip(title: "Keep to a healthy routine", tip: "Don’t use alcohol and drugs as a way of dealing with fear, anxiety, boredom and social isolation.", whoLink: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjKvsDD2ILrAhUKjq0KHf91ARYQ5KcGMAt6BAgFEA8&url=https%3A%2F%2Fwww.who.int%2Fnews-room%2Fcampaigns%2Fconnecting-the-world-to-combat-coronavirus%2Fhealthyathome%2Fhealthyathome---mental-health&usg=AOvVaw0_2X9ckgknvCHzcjabzkQT"),
        Tip(title: "Be kind to yourself and others", tip: "Don’t expect too much of yourself on difficult days. Accept that some days you may be more productive than others.", whoLink: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjKvsDD2ILrAhUKjq0KHf91ARYQ5KcGMAt6BAgFEBM&url=https%3A%2F%2Fwww.who.int%2Fpublications%2Fi%2Fitem%2F9789240003927&usg=AOvVaw2jUlMINAF_ihq3-rZMSbe1"),
        Tip(title: "Reach out for help if you need it", tip: "Don’t hesitate to seek professional help if you think you need it.", whoLink: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjKvsDD2ILrAhUKjq0KHf91ARYQ5acGMAt6BAgFEAM&url=https%3A%2F%2Fwww.who.int%2Fteams%2Fmental-health-and-substance-use%2Fcovid-19&usg=AOvVaw3bVrgpOwQRDND1mt6ayMz0")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleContainerViews()
        tableView.dataSource = self
    }
    
    func styleContainerViews(){
        topContainerView.layer.shadowColor = UIColor.black.cgColor
        topContainerView.layer.shadowOpacity = 0.2
        topContainerView.layer.shadowOffset = .zero
        topContainerView.layer.shadowRadius = 10
        
        tableView.layer.cornerRadius = 10
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = .zero
        tableView.layer.shadowRadius = 10
        
        /*let containerView:UIView = UIView(frame:CGRect(x: 10, y: 100, width: 300, height: 400))
        containerView.backgroundColor = UIColor.clear
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 2
            
        self.tableView.layer.cornerRadius = 10
        self.tableView.layer.masksToBounds = true
        self.view.addSubview(containerView)
        containerView.addSubview(self.tableView)*/
        
        backButton.layer.cornerRadius = 8
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.shadowOffset = .zero
        backButton.layer.shadowRadius = 5
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension CopingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tip = self.tips[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell", for: indexPath) as! CopingTableViewCell
        
        // Customize cell.
        cell.update(with: tip)
        
        return cell
    }
    
    
}
