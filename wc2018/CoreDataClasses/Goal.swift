//
//  Goal.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData


class Goal: ManagedObjectBase {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName("Goal"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)
    }
}
