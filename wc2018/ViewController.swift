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
    var currentDataVersion: Int = 0
    let xmlUpdateElement: String = "update"
    let xmlUpdateElementAttrVersion = "version"
    
    let gamesByGroup = CoreDataManager.instance.fetchedResultsController("Game", sorting: "date", grouping: "group")
    
    var cities:NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "City")
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.instance.managedObjectContext,sectionNameKeyPath: nil, cacheName: nil)
    }()
    
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
    
    // MARK: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try gamesByGroup.performFetch()
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gamesByGroup.sections?.count > 0 {
            return gamesByGroup.sections![section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let game = gamesByGroup.objectAtIndexPath(indexPath) as! Game
        let teamA = game.teamA as! Team
        let teamB = game.teamB as! Team
        
        let cell:CellGame = self.tableData.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CellGame!
        cell.labelTeamA.text = teamA.name
        cell.labelTeamB.text = teamB.name
        
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
        // is it an update element
        if elementName == xmlUpdateElement {
            let updateVersion: Int? = Int(attributeDict[xmlUpdateElementAttrVersion]!)!
            if updateVersion <= currentDataVersion {
                ignoreCurrentElement = true
                return
            }
        }
        
        // other element in an update
        if ignoreCurrentElement {
            return
        }
        
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if ignoreCurrentElement {
            return
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == xmlUpdateElement {
            ignoreCurrentElement = false
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        ignoreCurrentElement = false
        dataVersion = currentDataVersion
        parsingInProgress = false
    }
}

