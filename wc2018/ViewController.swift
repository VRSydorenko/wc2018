//
//  ViewController.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate {

    // MARK: outlets
    @IBOutlet weak var tableData: UITableView!
    
    // MARK: variables
    let cellReuseIdentifier: String = "cellGame"
    var parsingInProgress: Bool = false
    var ignoreCurrentUpdate: Bool = false
    var currentUpdateDataVersion: Int = 0
    let xmlUpdateElement: String = "update"
    let xmlUpdateElementAttrVersion = "version"
    
    let gamesByGroup = CoreDataManager.instance.fetchedResultsController("Game", predicate: nil, sorting: "date", grouping: "group")
    let countries = CoreDataManager.instance.fetchedResultsController("Country", predicate: nil, sorting: "name", grouping: nil)
    
    var dataVersion: Int {
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
    
    var parser : NSXMLParser?
    
    // MARK: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            //try gamesByGroup.performFetch()
            try countries.performFetch()
        } catch {
            print(error)
        }
        
        let url = NSURL(string: "https://dl.dropboxusercontent.com/s/m02s7944bcdytiq/wc2018.xml")
        parser = NSXMLParser(contentsOfURL: url!)
        parser!.delegate = self
        parser!.parse()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if gamesByGroup.sections?.count > 0 {
            return gamesByGroup.sections![section].numberOfObjects
        }*/
        if countries.sections?.count > 0 {
            return countries.sections![section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*let game = gamesByGroup.objectAtIndexPath(indexPath) as! Game
        let teamA = game.teamA! as Team
        let teamB = game.teamB! as Team
        
        let cell:CellGame = self.tableData.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CellGame!
        cell.labelTeamA.text = teamA.name
        cell.labelTeamB.text = teamB.name*/
        
        let country = countries.objectAtIndexPath(indexPath) as! Country
         
        let cell:CellGame = self.tableData.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CellGame!
        cell.labelTeamA.text = country.name
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        print("START document")
        parsingInProgress = true
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("START element \"\(elementName)\"...")
        
        // an update element?
        if elementName == xmlUpdateElement {
            currentUpdateDataVersion = Int(attributeDict[xmlUpdateElementAttrVersion]!)!
            if currentUpdateDataVersion <= dataVersion {
                print("Update will be ignored! Update version <\(currentUpdateDataVersion)> is less than current data version <\(dataVersion)>")
                ignoreCurrentUpdate = true
            } else {
                print("Update will apply! Update version <\(currentUpdateDataVersion)> is greater than current data version <\(dataVersion)>")
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
                print("Updating app data version (\(dataVersion)) to <\(currentUpdateDataVersion)>")
                dataVersion = currentUpdateDataVersion
            }
            
            ignoreCurrentUpdate = false
        }
        print("END element \"\(elementName)\"...")
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        parsingInProgress = false
        print("END document")
    }
}

