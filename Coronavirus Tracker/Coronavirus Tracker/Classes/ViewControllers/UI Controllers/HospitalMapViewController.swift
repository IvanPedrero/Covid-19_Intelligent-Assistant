//
//  HospitalMapViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 02/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

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
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK:- UI view containers.
    @IBOutlet weak var generalTopContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleContainerViews()
        initMaps()
    }
    
    func styleContainerViews(){
        generalTopContainerView.layer.shadowColor = UIColor.black.cgColor
        generalTopContainerView.layer.shadowOpacity = 0.2
        generalTopContainerView.layer.shadowOffset = .zero
        generalTopContainerView.layer.shadowRadius = 10
        
        backButton.layer.cornerRadius = 8
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.shadowOffset = .zero
        backButton.layer.shadowRadius = 5
    }
    
    func initMaps(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            mapView.showsUserLocation = true
            mapView.delegate = self
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
                        
        }else{
            dismiss (animated: true, completion: nil)
        }
    }
    
    func queryNearbyHospitals(region:MKCoordinateRegion){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "hospital"


        // Set the region to an associated map view's region.
        searchRequest.region = region


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
       mapView.addAnnotations([pin1])
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
       dismiss (animated: true, completion: nil)
    }
    
    
    // MARK:- External maps managing.
    func askForMapOpening(coordinates:CLLocationCoordinate2D, title:String){
        let alert = UIAlertController(title: "Opening directions to", message: title, preferredStyle: .alert)
        
        // Accessing alert view backgroundColor :
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white

        // Accessing buttons tintcolor :
        alert.view.tintColor = UIColor.systemPurple

        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            self.openMapsAppWithDirections(to: coordinates, destinationName: title)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
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

extension HospitalMapViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
       let location = locations.last! as CLLocation
       let currentLocation = location.coordinate
       let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 6500, longitudinalMeters: 6500)
        self.mapView.setRegion(coordinateRegion, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        self.queryNearbyHospitals(region: coordinateRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error.localizedDescription)
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        if let coordinates = annotation?.coordinate{
            if let title = annotation?.title ?? ""{
                self.mapView.deselectAnnotation(annotation, animated: true)
                self.askForMapOpening(coordinates: coordinates, title: title)
            }
        }
    }
}
