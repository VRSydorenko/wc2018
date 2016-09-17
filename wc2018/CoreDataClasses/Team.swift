//
//  Team.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData


class Team: NSManagedObject {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName("Team"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)
    }
}
