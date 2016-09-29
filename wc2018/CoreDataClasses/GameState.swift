//
//  GameState.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData

class GameState: ManagedObjectBase {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName("GameState"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)
    }
}
