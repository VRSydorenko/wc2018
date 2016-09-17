//
//  Country.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData


class Country: NSManagedObject {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName("Country"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)
    }
}
