//
//  ViewController.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataLoaderDelegate {
    
    // MARK: outlets
    @IBOutlet weak var tableData: UITableView!
    
    private let cellReuseIdentifier: String = "cellGame"
    
    private let updater = DataLoader()
    private let games = CoreDataManager.instance.fetchedResultsController("Game", predicate: nil, sorting: "date", grouping: "group")
    
    var data: NSFetchedResultsController {
        get {
            switch UserSettings.displayMode {
            case .rounds:
                return games
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updater.delegate = self
        updater.startUpdate()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func UpdateCompleted(success: Bool) {
        updateTable()
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