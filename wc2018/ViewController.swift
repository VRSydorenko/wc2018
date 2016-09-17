//
//  ViewController.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableData: UITableView!
    
    let cellReuseIdentifier: String = "cellGame"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CellGame = self.tableData.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CellGame!
        cell.labelTeamA.text = "AAA"
        cell.labelTeamB.text = "BBB"
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

