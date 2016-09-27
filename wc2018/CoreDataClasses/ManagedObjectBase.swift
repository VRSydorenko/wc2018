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
        case "date", "begin", "end":
            if let date = UserSettings.dateFormatter.dateFromString(value) {
                super.setValue((date as AnyObject), forKey: key)
                print("Setting [date] to <\(date)>")
            } else {
                print("Error formatting <\(value)> into Date [date]!")
            }
        case "country":
            if let id = Int(value) {
                if let country = CoreDataManager.instance.entityObjectById("Country", id: id) {
                    super.setValue(country as AnyObject, forKey: key)
                    print("Setting [country] to a Country object with id <\(id)>")
                }
            } else {
                print("Error casting Country id <\(value)> to Int [id]!")
            }
        case "city":
            if let id = Int(value) {
                if let city = CoreDataManager.instance.entityObjectById("City", id: id) {
                    super.setValue(city as AnyObject, forKey: key)
                    print("Setting [city] to a City object with id <\(id)>")
                }
            } else {
                print("Error casting City id <\(value)> to Int [id]!")
            }
        default:
            print("Setting [\(key)] to <\(value)>")
            setValue(value, forKey: key)
        }
    }
}
