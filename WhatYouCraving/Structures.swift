//
//  Structures.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 16/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation

struct RestaurantDetails {
    
    var location: RestaurantLoc!
    var name: String!
    var zomatoUrl: String!
    var cuisine: String
    
    
    init(name: String, url: String, location: RestaurantLoc, cuisine: String) {
        
        self.name = name
        self.zomatoUrl = url
        self.cuisine = cuisine
        self.location = location
    }
}

struct RestaurantLoc {
    
    var lat: Double!
    var long: Double!
    
    init(lat: Double, long: Double) {
        
        self.lat = lat
        self.long = long
    }
}

struct LocationUser {
    
    var lat: Double!
    var long: Double!
    var city: String!
    
    init(lat: Double, long: Double, city: String) {
        
        self.lat = lat
        self.long = long
        self.city = city
    }
}
