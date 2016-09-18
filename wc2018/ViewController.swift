//
//  ViewController.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableData: UITableView!
    
    let cellReuseIdentifier: String = "cellGame"
    
    var gamesByGroup:NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "Game")
        let sorting = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sorting]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: "group", cacheName: nil)
        
        return controller
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
}

