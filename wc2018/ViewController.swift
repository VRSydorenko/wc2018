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
    
    var currentRound: Round? {
        get {
            rounds.fetchRequest.predicate = NSPredicate(format: "end >= %@", NSDate())
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
    
    func getPrevRound(forRound: Round?) -> Round? {
        if forRound == nil {
            return nil
        }
        
        rounds.fetchRequest.predicate = NSPredicate(format: "end < %@", forRound!.beginDate)
        do {
            try rounds.performFetch()
            if rounds.fetchedObjects?.count > 0 {
                return rounds.fetchedObjects?.last as! Round!
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func getNextRound(forRound: Round?) -> Round? {
        if forRound == nil {
            return nil
        }
        
        rounds.fetchRequest.predicate = NSPredicate(format: "begin > %@", forRound!.endDate)
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
    
    func OnUpdateCompleted(success: Bool) {
        updateTable()
    }
    
    func updateTable(){
        updateRequests()
        
        naviCurrent.title = currentRound?.name
        naviPrev.title = getPrevRound(currentRound)?.name
        naviFwd.title = getNextRound(currentRound)?.name

        do{
            print("Fetching data..")
            try data.performFetch()
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