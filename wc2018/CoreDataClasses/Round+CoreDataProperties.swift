//
//  Round+CoreDataProperties.swift
//  wc2018
//
//  Created by VRS on 25/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Round {

    @NSManaged var group: String?
    @NSManaged var id: Int32
    @NSManaged var name: String?
    @NSManaged var begin: NSTimeInterval
    @NSManaged var end: NSTimeInterval
    @NSManaged var games: NSSet?

}
