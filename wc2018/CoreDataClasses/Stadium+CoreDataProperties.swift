//
//  Stadium+CoreDataProperties.swift
//  wc2018
//
//  Created by VRS on 29/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Stadium {

    @NSManaged var id: Int32
    @NSManaged var name: String?
    @NSManaged var city: City?
    @NSManaged var games: NSSet?

}
