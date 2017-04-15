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

enum TournamentMode {
    case national
    case international
}

class UserSettings {
    static var dataVersion: Int {
        get {
            if let returnValue = UserDefaults.standard.object(forKey: "dataVersion") as? Int {
                return returnValue
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dataVersion")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var displayMode: DisplayMode {
        get {
            if let modeValue = UserDefaults.standard.object(forKey: "displayMode") as? Int {
                return DisplayMode.init(rawValue: modeValue)!
            }
            return .rounds
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "displayMode")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var currentRoundId: Int {
        get {
            if let returnValue = UserDefaults.standard.object(forKey: "currentRound") as? Int {
                return returnValue
            }
            return 1
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentRound")
            UserDefaults.standard.synchronize()
        }
    }
    
    static let tournamentMode : TournamentMode = .national
    
    static let dataUrl = URL(string: "https://dl.dropboxusercontent.com/s/m02s7944bcdytiq/wc2018.xml")
    
    static var dateFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter
        }
    }
    
    static let editorMode = false
}
