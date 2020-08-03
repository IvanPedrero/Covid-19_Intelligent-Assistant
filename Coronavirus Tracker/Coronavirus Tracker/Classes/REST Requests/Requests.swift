//
//  Requests.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 02/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import Foundation
import  UIKit

class Requests {
        
    /// Request to get the general summary from the API for the home screen.
    static func getSummaryInformation(completion: @escaping (Dictionary<String, AnyObject>?)->()) {
        //create the url with NSURL
        let url = URL(string: "https://api.covid19api.com/summary")!

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let global = json["Global"] as? Dictionary<String, AnyObject>{
                        completion(global)
                    }

                }
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        })

        task.resume()
    }
    
    /// Request to get the country information from the API for the home screen.
    static func getCountryInformation(completion: @escaping ([Dictionary<String, AnyObject>]?)->()) {
        //create the url with NSURL
        let url = URL(string: "https://api.covid19api.com/summary")!

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let global = json["Countries"] as? [Dictionary<String, AnyObject>]{
                        completion(global)
                    }

                }
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        })

        task.resume()
    }
    
    /// Opens the WHO coronavirus website.
    static func openWhoWebsite(){
        if let url = URL(string: "https://www.who.int/health-topics/coronavirus#tab=tab_1") {
            UIApplication.shared.open(url)
        }
    }
}
