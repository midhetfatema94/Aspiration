//
//  RestaurantInfo+CoreDataProperties.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 16/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation
import CoreData


extension RestaurantInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantInfo> {
        return NSFetchRequest<RestaurantInfo>(entityName: "RestaurantInfo");
    }

    @NSManaged public var name: String?
    @NSManaged public var cuisine: String?
    @NSManaged public var menuUrl: String?
    @NSManaged public var myLocation: RestaurantLocation?
    @NSManaged public var userLocation: UserLocation?

}
