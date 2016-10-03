//
//  NewObjectVC.swift
//  wc2018
//
//  Created by VRS on 30/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewObjectVC : UITableViewController {
    var newObject: ManagedObjectBase? = nil
    
    override func viewDidLoad() {
        //tableView.contentInset.top = UIApplication.sharedApplication().statusBarFrame.height
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newObject != nil {
            if section == 0 { // attributes
                return newObject!.entity.attributesByName.count
            } else if section == 1 { // properties (relationships)
                return newObject!.entity.relationshipsByName.count
            }
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if newObject != nil {
            if section == 0 { // attributes
                return "Attributes"
            } else if section == 1 { // relationships
                return "Relations"
            }
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellAttribute")
        var text = ""
        
        if newObject != nil {
            if indexPath.section == 0 { // attributes
                text = Array(newObject!.entity.attributesByName.keys)[indexPath.row]
            } else if indexPath.section == 1 { // relationships
                text = Array(newObject!.entity.relationshipsByName.keys)[indexPath.row]
            }
        } else {
            cell?.textLabel?.text = "object is nil"
            return cell!
        }
        
        cell?.textLabel?.text = text
        
        // color
        var color = UIColor.redColor()
        if let property = newObject!.entity.propertiesByName[text] {
            if newObject!.valueForKey(text) != nil {
                color = UIColor.greenColor()
            }
            
            if property.optional {
                color = UIColor.grayColor()
            }
        }
        cell?.textLabel?.textColor = color
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}