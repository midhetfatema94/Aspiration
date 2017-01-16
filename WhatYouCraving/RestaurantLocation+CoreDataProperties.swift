//
//  RestaurantLocation+CoreDataProperties.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 16/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation
import CoreData


extension RestaurantLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantLocation> {
        return NSFetchRequest<RestaurantLocation>(entityName: "RestaurantLocation");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var info: RestaurantInfo?

}
