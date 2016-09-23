//
//  ManagedObjectBase.swift
//  wc2018
//
//  Created by VRS on 22/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData

class ManagedObjectBase : NSManagedObject{
    func setValuesFromDictionary(dict: [String : String]){
        for (key, value) in dict {
            self.setValueForKey(value, forKey: key)
        }
    }
    
    func setValueForKey(value: String, forKey key: String) {
        switch key {
        case "id":
            if let id = Int(value) {
                super.setValue((id as AnyObject), forKey: key)
                print("Setting [id] to <\(id)>")
            } else {
                print("Error casting <\(value)> to Int [id]!")
            }
        case "date":
            let formatter = NSDateFormatter()
            if let date = formatter.dateFromString(value) {
                super.setValue((date as AnyObject), forKey: key)
                print("Setting [date] to <\(date)>")
            } else {
                print("Error formatting <\(value)> into Date [date]!")
            }
        default:
            print("Setting [\(key)] to <\(value)>")
            setValue(value, forKey: key)
        }
    }
}
