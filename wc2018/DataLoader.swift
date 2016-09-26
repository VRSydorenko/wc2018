//
//  DataLoader.swift
//  wc2018
//
//  Created by VRS on 26/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation

protocol DataLoaderDelegate {
    func UpdateCompleted(success: Bool)
}

class DataLoader : NSObject, NSXMLParserDelegate {
    
    static let instance = DataLoader()
    
    var delegate: DataLoaderDelegate?
    private var parser = NSXMLParser(contentsOfURL: UserSettings.dataUrl!)!
    
    private var ignoreCurrentUpdate: Bool = false
    private var currentUpdateDataVersion: Int = 0
    private let xmlUpdateElement: String = "update"
    private let xmlUpdateElementAttrVersion = "version"
    
    var updateInProgress: Bool {
        get {
            return parsingInProgress
        }
    }
    private var parsingInProgress: Bool = false
    
    override init(){
        super.init()
        
        parser.delegate = self
    }
    
    func startUpdate(){
        if updateInProgress {
            return
        }
        
        parsingInProgress = true
        parser.parse()
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        print("START document")
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("START element \"\(elementName)\"...")
        
        // an update element?
        if elementName == xmlUpdateElement {
            currentUpdateDataVersion = Int(attributeDict[xmlUpdateElementAttrVersion]!)!
            if currentUpdateDataVersion <= UserSettings.dataVersion {
                print("Update will be ignored! Update version <\(currentUpdateDataVersion)> is less than current data version <\(UserSettings.dataVersion)>")
                ignoreCurrentUpdate = true
            } else {
                print("Update will apply! Update version <\(currentUpdateDataVersion)> is greater than current data version <\(UserSettings.dataVersion)>")
            }
            return
        }
        
        // other element in an update
        if ignoreCurrentUpdate {
            print("We are ingnoring this update...")
            return
        }
        
        let idValue = attributeDict["id"]
        if idValue == nil {
            print("The element doesn't have the id and won't be processed!")
            return
        }
        
        let id : Int! = Int(idValue!)
        print("The element has id: \(id)")
        let objects = CoreDataManager.instance.fetchedResultsController(elementName, id: id)
        
        do{
            print("Fetch...")
            try objects.performFetch()
        } catch {
            print("Failed!")
            print(error)
        }
        
        var object : ManagedObjectBase?
        
        var anyEntity: AnyObject? = nil
        
        if objects.fetchedObjects!.count > 0 {
            print("Yes, the object exists")
            anyEntity = objects.objectAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        }
        
        CoreDataManager.instance.castOrCreate(elementName, object: anyEntity, entity: &object)
        
        // set object values and save
        if let object = object {
            object.setValuesFromDictionary(attributeDict)
            print("Save!")
            CoreDataManager.instance.saveContext()
        } else {
            print("ERROR!!! Object cast/creation failed!")
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == xmlUpdateElement {
            if !ignoreCurrentUpdate {
                print("Updating app data version (\(UserSettings.dataVersion)) to <\(currentUpdateDataVersion)>")
                UserSettings.dataVersion = currentUpdateDataVersion
            }
            
            ignoreCurrentUpdate = false
        }
        print("END element \"\(elementName)\"...")
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        parsingInProgress = false
        print("END document")
        
        if parser.parserError == nil {
            print("Parsing succeeded!")
        } else {
            print("Parsing failed!")
            print(parser.parserError)
        }
        
        delegate?.UpdateCompleted(parser.parserError == nil)
    }
}