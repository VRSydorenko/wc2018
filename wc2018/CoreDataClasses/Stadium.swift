//
//  Stadium.swift
//  wc2018
//
//  Created by VRS on 29/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData

class Stadium: ManagedObjectBase {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName("Stadium"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)
    }
}
