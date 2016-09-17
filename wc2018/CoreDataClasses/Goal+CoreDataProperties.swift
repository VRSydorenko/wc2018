//
//  Goal+CoreDataProperties.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Goal {

    @NSManaged var minute: Int16
    @NSManaged var from: NSManagedObject?
    @NSManaged var to: NSManagedObject?
    @NSManaged var game: Game?

}