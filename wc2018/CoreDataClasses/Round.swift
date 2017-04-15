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
        self.init(entity: CoreDataManager.instance.entityForName("Round"), insertInto: CoreDataManager.instance.managedObjectContext)    }
    
    var beginDate: Date {
        get {
            return Date.init(timeInterval: begin, since: UserSettings.dateFormatter.date(from: "01.01.2001")!)
        }
    }
    
    var endDate: Date {
        get {
            return Date.init(timeInterval: end, since: UserSettings.dateFormatter.date(from: "01.01.2001")!)
        }
    }
}
