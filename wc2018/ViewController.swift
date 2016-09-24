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
    var parser = NSXMLParser(contentsOfURL: UserSettings.dataUrl!)!
    var parsingInProgress: Bool = false
    var ignoreCurrentUpdate: Bool = false
    var currentUpdateDataVersion: Int = 0
    let xmlUpdateElement: String = "update"
    let xmlUpdateElementAttrVersion = "version"
    
    let games = CoreDataManager.instance.fetchedResultsController("Game", predicate: nil, sorting: "date", grouping: "group")
    
    var data: NSFetchedResultsController {
        get {
            switch UserSettings.displayMode {
            case .rounds:
                return games
            }
        }
    }
    
    // MARK: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser.delegate = self
        
        performDataUpdate()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if gamesByGroup.sections?.count > 0 {
            return gamesByGroup.sections![section].numberOfObjects
        }*/
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let game = games.objectAtIndexPath(indexPath) as! Game
        let teamA = game.teamA! as Team
        let teamB = game.teamB! as Team
        
        let cell:CellGame = self.tableData.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CellGame!
        cell.labelTeamA.text = teamA.name
        cell.labelTeamB.text = teamB.name
        
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
    }
    
    func performDataUpdate(){
        if parser.parse(){
            print("Parsing succeeded!")
            updateTable()
        } else {
            print("Parsing failed!")
        }
    }
    
    func updateTable(){
        do{
            print("Fetching data..")
            try data.performFetch()
        } catch {
            print(error)
        }
        
        print("Table update..")
        tableData.reloadData()
    }
}

