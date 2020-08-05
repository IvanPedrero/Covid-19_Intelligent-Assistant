//
//  CopingTableViewCell.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 04/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit

class CopingTableViewCell: UITableViewCell {

    @IBOutlet weak var tipTitle: UILabel!
    @IBOutlet weak var tipDescription: UILabel!
    @IBOutlet weak var whoButton: UIButton!
    
    var link:String! = ""
    
    func update(with tip:Tip){
        tipTitle.text = tip.title
        tipDescription.text = tip.tip
        link = tip.whoLink
    }
    
    @IBAction func whoAction(_ sender: Any) {
        Requests.openWebsite(with: link)
    }
    
}
