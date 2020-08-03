//
//  HospitalMapViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 02/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import MapKit


class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D

    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
}

class HospitalMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        queryNearbyHospitals()
    }
    
    func queryNearbyHospitals(){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "hospital"


        // Set the region to an associated map view's region.
        searchRequest.region = mapView.region


        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                // Handle the error.
                return
            }
            
            for item in response.mapItems {
                if let name = item.name,
                    let location = item.placemark.location {
                    print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
                    self.setPinUsingMKAnnotation(title: name, location: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                }
            }
        }
    }
    
    func setPinUsingMKAnnotation(title:String, location: CLLocationCoordinate2D) {
       let pin1 = MapPin(title: title, locationName: "", coordinate: location)
       let coordinateRegion = MKCoordinateRegion(center: pin1.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       mapView.addAnnotations([pin1])
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
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
