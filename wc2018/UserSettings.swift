//
//  UserSettings.swift
//  wc2018
//
//  Created by VRS on 23/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation

enum DisplayMode : Int {
    case rounds = 1
}

class UserSettings {
    static var dataVersion: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("dataVersion") as? Int {
                return returnValue
            }
            return 0
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "dataVersion")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var displayMode: DisplayMode {
        get {
            if let modeValue = NSUserDefaults.standardUserDefaults().objectForKey("displayMode") as? Int {
                return DisplayMode.init(rawValue: modeValue)!
            }
            return .rounds
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: "displayMode")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var currentRoundId: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("currentRound") as? Int {
                return returnValue
            }
            return 1
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "currentRound")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}