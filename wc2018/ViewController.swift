//
//  ViewController.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataLoaderDelegate {
    // MARK: outlets
    @IBOutlet weak var naviFwd: UIBarButtonItem!
    @IBOutlet weak var naviPrev: UIBarButtonItem!
    @IBOutlet weak var naviCurrent: UIBarButtonItem!
    @IBOutlet weak var tableData: UITableView!
    
    fileprivate let cellReuseIdentifier: String = "cellGame"
    
    fileprivate let updater = DataLoader()
    fileprivate let games = CoreDataManager.instance.fetchedResultsController("Game", predicate: nil, sorting: "date", grouping: nil/*"group"*/)
    fileprivate let rounds = CoreDataManager.instance.fetchedResultsController("Round", predicate: nil, sorting: "begin", grouping: nil)
    
    var data: NSFetchedResultsController<NSFetchRequestResult> {
        get {
            switch UserSettings.displayMode {
            case .rounds:
                return games
            }
        }
    }
    
    var currentRound: Round? {
        get {
            if vCurrentRound != nil {
                return vCurrentRound
            }
            
            rounds.fetchRequest.predicate = NSPredicate(format: "end >= %@", Date() as CVarArg)
            do {
                try rounds.performFetch()
                if rounds.fetchedObjects?.count > 0 {
                    vCurrentRound = rounds.fetchedObjects?.first as! Round!
                }
            } catch {
                print(error)
            }
            
            return vCurrentRound
        }
        
        set {
            vCurrentRound = newValue
        }
    }
    var vCurrentRound: Round? = nil
    
    var predGamesOfCurrentRound: NSPredicate? {
        get {
            if let round = currentRound {
                return NSPredicate(format: "round = %@", round)
            }
            return nil
        }
    }
    
    @IBAction func OnNaviPrevRoundPressed(_ sender: AnyObject) {
        if let prevRound = getPrevRound(currentRound) {
            currentRound = prevRound
            
            updateTable()
        }
        
        updateNaviTitles()
    }
    
    @IBAction func OnNaviNextRoundPressed(_ sender: AnyObject) {
        if let nextRound = getNextRound(currentRound) {
            currentRound = nextRound
            
            updateTable()
        }
        
        updateNaviTitles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updater.delegate = self
        updater.startUpdate()
    }
    
    func getPrevRound(_ forRound: Round?) -> Round? {
        if forRound == nil {
            return nil
        }
        
        rounds.fetchRequest.predicate = NSPredicate(format: "end < %@ AND id != %d", forRound!.beginDate as CVarArg, forRound!.id)
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
    
    func getNextRound(_ forRound: Round?) -> Round? {
        if forRound == nil {
            return nil
        }
        
        rounds.fetchRequest.predicate = NSPredicate(format: "begin > %@ AND id != %d", forRound!.endDate as CVarArg, forRound!.id)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.sections?.count > 0 {
            return data.sections![section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games.object(at: indexPath) as! Game
        let teamA = game.teamA! as Team
        let teamB = game.teamB! as Team
        
        let cell:CellGame = self.tableData.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CellGame!
        cell.labelTeamA.text = teamA.name
        cell.labelTeamB.text = teamB.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNewObject" {
            if let vc = segue.destination as? NewObjectVC {
                vc.newObject = Game()
            }
        }
    }
    
    func OnUpdateCompleted(_ success: Bool) {
        updateNaviTitles()
        updateTable()
    }
    
    func updateNaviTitles() {
        naviCurrent.title = currentRound?.name
        naviPrev.title = getPrevRound(currentRound)?.name
        naviFwd.title = getNextRound(currentRound)?.name
    }
    
    func updateTable(){
        updateRequests()

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
