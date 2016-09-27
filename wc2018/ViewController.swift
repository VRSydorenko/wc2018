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
    @IBOutlet weak var naviFwd: UIBarButtonItem!
    @IBOutlet weak var naviPrev: UIBarButtonItem!
    @IBOutlet weak var naviCurrent: UIBarButtonItem!
    @IBOutlet weak var tableData: UITableView!
    
    private let cellReuseIdentifier: String = "cellGame"
    
    private let updater = DataLoader()
    private let games = CoreDataManager.instance.fetchedResultsController("Game", predicate: nil, sorting: "date", grouping: "group")
    private let rounds = CoreDataManager.instance.fetchedResultsController("Round", predicate: nil, sorting: "begin", grouping: nil)
    
    var data: NSFetchedResultsController {
        get {
            switch UserSettings.displayMode {
            case .rounds:
                return games
            }
        }
    }
    
    var predCurrentRound : NSPredicate {
        get {
            let datePredicate = NSPredicate(format: "end >= %@", NSDate())
            return datePredicate
        }
    }
    
    var currentRound: Round? {
        get {
            rounds.fetchRequest.predicate = predCurrentRound
            do {
                try rounds.performFetch()
                if rounds.fetchedObjects?.count > 0 {
                    return rounds.fetchedObjects?.first as! Round!
                }
            } catch {
                print(error)
            }
            
            return nil
        }
    }
    
    var predGamesOfCurrentRound: NSPredicate? {
        get {
            if let round = currentRound {
                return NSPredicate(format: "round = %@", round)
            }
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updater.delegate = self
        updater.startUpdate()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.sections?.count > 0 {
            return data.sections![section].numberOfObjects
        }
        
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
        updateRequests()
        do{
            print("Fetching data..")
            try rounds.performFetch()
            try data.performFetch()
            
            naviCurrent.title = currentRound?.name
        } catch {
            print(error)
        }
        
        print("Table update..")
        tableData.reloadData()
    }
    
    func updateRequests(){
        games.fetchRequest.predicate = predGamesOfCurrentRound
    }
}