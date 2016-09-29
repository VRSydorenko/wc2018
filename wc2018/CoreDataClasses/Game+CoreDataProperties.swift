//
//  Game+CoreDataProperties.swift
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

extension Game {

    @NSManaged var date: NSTimeInterval
    @NSManaged var id: Int32
    @NSManaged var goals: NSSet?
    @NSManaged var round: Round?
    @NSManaged var state: GameState?
    @NSManaged var teamA: Team?
    @NSManaged var teamB: Team?
    @NSManaged var stadium: NSManagedObject?

}
