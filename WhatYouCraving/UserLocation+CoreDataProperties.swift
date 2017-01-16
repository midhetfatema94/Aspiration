//
//  UserLocation+CoreDataProperties.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 16/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation
import CoreData


extension UserLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLocation> {
        return NSFetchRequest<UserLocation>(entityName: "UserLocation");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var city: String?
    @NSManaged public var cuisine: String
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for restaurants
extension UserLocation {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: RestaurantInfo)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: RestaurantInfo)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
