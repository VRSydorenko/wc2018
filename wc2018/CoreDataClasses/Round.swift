//
//  Round.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData

class Round: ManagedObjectBase {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName("Round"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)    }
    
    var beginDate: NSDate {
        get {
            return NSDate.init(timeInterval: begin, sinceDate: UserSettings.dateFormatter.dateFromString("01.01.2001")!)
        }
    }
    
    var endDate: NSDate {
        get {
            return NSDate.init(timeInterval: end, sinceDate: UserSettings.dateFormatter.dateFromString("01.01.2001")!)
        }
    }
}
