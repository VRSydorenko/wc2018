//
//  Game+CoreDataProperties.swift
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

extension Game {

    @NSManaged var date: NSTimeInterval
    @NSManaged var city: NSManagedObject?
    @NSManaged var teamA: NSManagedObject?
    @NSManaged var teamB: NSManagedObject?
    @NSManaged var goals: NSSet?
    @NSManaged var round: NSManagedObject?
    @NSManaged var state: NSManagedObject?

}
