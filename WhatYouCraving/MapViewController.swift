//
//  MapViewController.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 29/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var selectedCuisine: UILabel!
    @IBAction func changeCuisine(_ sender: Any) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    var cuisineName = ""
    var cityName = ""
    let locationManager = CLLocationManager()
    var allRestaurants: [RestaurantDetails] = []
    var annotations: [MKPointAnnotation] = []
    let apiAlerts = Alert()
    var activity = UIActivityIndicatorView()
    var didFindLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCuisine.text = "Craving \(cuisineName) Food!" 
        Map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        activity.center = self.view.center
        activity.color = UIColor.black
        self.view.addSubview(activity)
        activity.isHidden = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let myLocation = manager.location {
            if !didFindLocation {
                
                let locValue: CLLocationCoordinate2D = myLocation.coordinate
                getCuisinePlaces(lat: locValue.latitude, long: locValue.longitude)
                didFindLocation = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                print("media url: \(toOpen)")
                
                if toOpen != "" {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func getCuisinePlaces(lat: Double, long: Double) {
        
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        let latDelta:CLLocationDegrees = 1.5
        let lonDelta:CLLocationDegrees = 1.5
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.Map.setRegion(region, animated: false)
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLocation")
        let pin = try! coreData.context.fetch(fr) as! [UserLocation]
        
        print("match this info:", lat, long, cuisineName)
        var matchingPins: [UserLocation] = []
        
        for eachPin in pin {
            
            print("pin info:", eachPin.latitude, eachPin.longitude, eachPin.cuisine)
            if eachPin.latitude == lat && eachPin.longitude == long && eachPin.cuisine == cuisineName {
                
                print("found matching pin!")
                matchingPins.append(eachPin)
            }
        }
        
        print("searching core data:", pin.count)
        
        if matchingPins.count > 0 {
            
            print("using core data")
            
            let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantInfo")
            fr.predicate = NSPredicate(format: "userLocation = %@", argumentArray: matchingPins)
            let restaurants = try! coreData.context.fetch(fr) as! [RestaurantInfo]
            
            if restaurants.count > 0 {
                
                for eachRest in restaurants {
                    
                    let rest = RestaurantDetails(name: eachRest.name!, url: eachRest.menuUrl!, location: RestaurantLoc(lat: eachRest.myLocation!.latitude, long: eachRest.myLocation!.longitude), cuisine: cuisineName)
                    allRestaurants.append(rest)
                }
                setList()
            }
            else {
                
                self.activity.isHidden = false
                self.activity.startAnimating()
                getDataFromAPI(lat: lat, long: long)
            }
        }
        
        else {
            
            self.activity.isHidden = false
            self.activity.startAnimating()
            getDataFromAPI(lat: lat, long: long)
        }
    }
    
    func getDataFromAPI(lat: Double, long: Double) {
        
        request.getZomatoRestaurantList(lat: lat, long: long, cuisineId: cuisineName, controller: self, completion: {response in
            
            DispatchQueue.main.async {
                
                self.activity.isHidden = true
                self.activity.stopAnimating()
                
                if response["code"] != nil {
                    
                    print("error", response)
                    self.apiAlerts.showAlert(title: "Error!", message: response["message"] as! String, vc: self)
                }
                else {
                    
                    let allResponses = response["restaurants"] as! [[String: Any]]
                    
                    if allResponses.count > 0 {
                        
                        for eachResponse in allResponses {
                            
                            let restaurantObject = eachResponse["restaurant"] as! [String: Any]
                            let location = restaurantObject["location"] as! [String: Any]
                            let restaurant = RestaurantDetails(name: restaurantObject["name"] as! String, url: restaurantObject["menu_url"] as! String, location: RestaurantLoc(lat: Double(location["latitude"] as! String)!, long: Double(location["longitude"] as! String)!), cuisine: restaurantObject["cuisines"] as! String)
                            self.allRestaurants.append(restaurant)
                        }
                        self.saveData(restInfo: self.allRestaurants, userInfo: LocationUser(lat: lat, long: long, city: self.cityName))
                        self.setList()
                    }
                    else {
                        self.apiAlerts.showAlert(title: "Sorry", message: "No restaurants found!", vc: self)
                    }
                }
            }
        })
    }
    
    func saveData(restInfo: [RestaurantDetails], userInfo: LocationUser) {
        
//        DispatchQueue.init(label: "newQueue").async {
        
            print("saving core data")
            
            let newPin = NSEntityDescription.insertNewObject(forEntityName: "UserLocation", into: coreData.context) as! UserLocation
            newPin.city = userInfo.city
            newPin.cuisine = self.cuisineName
            newPin.latitude = userInfo.lat
            newPin.longitude = userInfo.long
            print(newPin)
            
            for each in restInfo {
                
                let newRestLocation = NSEntityDescription.insertNewObject(forEntityName: "RestaurantLocation", into: coreData.context) as! RestaurantLocation
                newRestLocation.latitude = each.location.lat
                newRestLocation.longitude = each.location.long
                print(newRestLocation)
                
                let newRest = NSEntityDescription.insertNewObject(forEntityName: "RestaurantInfo", into: coreData.context) as! RestaurantInfo
                newRest.cuisine = self.cuisineName
                newRest.menuUrl = each.zomatoUrl
                newRest.name = each.name
                newRest.userLocation = newPin
                newRest.myLocation = newRestLocation
                print(newRest)
            }
        
//            do {
//                try coreData.stack.dropAllData()
//            } catch {
//                print("Error while dropping data")
//            }
        
            do {
                try coreData.stack.saveContext()
            } catch {
                print("Error while saving.")
            }
//        }
    }
    
    func setList() {
        
        let listVC = self.tabBarController?.viewControllers?.last as! ListViewController
        listVC.restaurantList = self.allRestaurants
        self.getPins()
    }
    
    func getPins() {
        
        for eachRestaurant in allRestaurants {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(eachRestaurant.location.lat)
            //            print("lat: \(lat)")
            let long = CLLocationDegrees(eachRestaurant.location.long)
            //            print("long: \(long)")
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            var first = ""
            
            if eachRestaurant.name != nil && eachRestaurant.name != "" {
                first = eachRestaurant.name
            }
            
            var mediaURL = ""
            
            if eachRestaurant.zomatoUrl != nil && eachRestaurant.zomatoUrl != "" {
                mediaURL = eachRestaurant.zomatoUrl
            }
            
            print("creating annotations \(lat) \(long)")
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = first
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.Map.addAnnotations(annotations)
    }
}
