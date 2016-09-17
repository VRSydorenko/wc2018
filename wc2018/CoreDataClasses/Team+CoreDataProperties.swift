//
//  Team+CoreDataProperties.swift
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

extension Team {

    @NSManaged var name: String?
    @NSManaged var country: Country?
    @NSManaged var teamA: NSSet?
    @NSManaged var teamB: NSSet?
    @NSManaged var goalsFrom: Goal?
    @NSManaged var goalsTo: Goal?

}