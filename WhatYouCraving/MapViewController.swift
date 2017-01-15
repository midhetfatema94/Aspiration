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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var selectedCuisine: UILabel!
    @IBAction func changeCuisine(_ sender: Any) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    var cuisineName = ""
    let locationManager = CLLocationManager()
    var allRestaurants: [RestaurantDetails] = []
    var annotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCuisine.text = "Craving \(cuisineName) Food!" 
        Map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let myLocation = manager.location {
            let locValue: CLLocationCoordinate2D = myLocation.coordinate
            getCuisinePlaces(lat: locValue.latitude, long: locValue.longitude)
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
        
        request.getZomatoRestaurantList(lat: lat, long: long, cuisineId: cuisineName, completion: {response in
            
            DispatchQueue.main.async {
                
                if response["code"] != nil {
                }
                else {
                    
                    let allResponses = response["restaurants"] as! [[String: Any]]
                    
                    for eachResponse in allResponses {
                        
                        let restaurantObject = eachResponse["restaurant"] as! [String: Any]
                        let location = restaurantObject["location"] as! [String: Any]
                        let restaurant = RestaurantDetails(name: restaurantObject["name"] as! String, url: restaurantObject["menu_url"] as! String, location: RestaurantLocation(lat: Double(location["latitude"] as! String)!, long: Double(location["longitude"] as! String)!, city: location["city"] as! String), cuisine: restaurantObject["cuisines"] as! String)
                        self.allRestaurants.append(restaurant)
                    }
                    let listVC = self.tabBarController?.viewControllers?.last as! ListViewController
                    listVC.restaurantList = self.allRestaurants
                    self.getPins()
                }
            }
        })
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

struct RestaurantDetails {
    
    var location: RestaurantLocation!
    var name: String!
    var zomatoUrl: String!
    var cuisine: String
    
    
    init(name: String, url: String, location: RestaurantLocation, cuisine: String) {
        
        self.name = name
        self.zomatoUrl = url
        self.cuisine = cuisine
        self.location = location
    }
}

struct RestaurantLocation {
    
    var lat: Double!
    var long: Double!
    var city: String!
    
    init(lat: Double, long: Double, city: String) {
        
        self.lat = lat
        self.long = long
        self.city = city
    }
}
