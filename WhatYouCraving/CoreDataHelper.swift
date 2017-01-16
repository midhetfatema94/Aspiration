//
//  CoreDataHelper.swift
//  VirtualTourister
//
//  Created by Midhet Sulemani on 10/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    let stack = CoreDataStack(modelName: "Model")!
    var context:NSManagedObjectContext
    
    init() {
        context = stack.context
    }
}
