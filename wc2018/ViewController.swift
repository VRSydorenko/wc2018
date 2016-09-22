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
    var ignoreCurrentElement: Bool = false
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
    
    // MARK: xml parsing
    func parserDidStartDocument(parser: NSXMLParser) {
        parsingInProgress = true
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        // is it an update element?
        if elementName == xmlUpdateElement {
            let updateVersion: Int? = Int(attributeDict[xmlUpdateElementAttrVersion]!)!
            if updateVersion <= currentUpdateDataVersion {
                ignoreCurrentElement = true
            }
            return
        }
        
        // other element in an update
        if ignoreCurrentElement {
            return
        }
        
        if let idValue = attributeDict["id"] {
            let id : Int = Int(idValue)!
            let objects = CoreDataManager.instance.fetchedResultsController(elementName, id: id)
            
            do{
                try objects.performFetch()
            } catch {
                print(error)
            }
            
            var object : ManagedObjectBase?
            
            // existing entity
            if objects.fetchedObjects!.count > 0 {
                let obj = objects.objectAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                switch elementName {
                case "Country":
                    object = obj as? Country
                case "Game":
                    object = obj as? Game
                case "Goal":
                    object = obj as? Goal
                case "Round":
                    object = obj as? Round
                case "City":
                    object = obj as? City
                case "GameState":
                    object = obj as? GameState
                case "Team":
                    object = obj as? Team
                default: break
                }
            }
            // need to add a new entity
            else{
                switch elementName {
                case "Country":
                    object = Country()
                case "Game":
                    object = Game()
                case "Goal":
                    object = Goal()
                case "Round":
                    object = Round()
                case "City":
                    object = City()
                case "GameState":
                    object = GameState()
                case "Team":
                    object = Team()
                default: break
                }
            }
            
            // set object values and save
            if let object = object {
                object.setValuesFromDictionary(attributeDict)
                CoreDataManager.instance.saveContext()
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == xmlUpdateElement {
            dataVersion = currentUpdateDataVersion
            ignoreCurrentElement = false
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        parsingInProgress = false
    }
}

