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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newObject != nil {
            if section == 0 { // attributes
                return newObject!.entity.attributesByName.count
            } else if section == 1 { // properties (relationships)
                return newObject!.entity.relationshipsByName.count
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if newObject != nil {
            if section == 0 { // attributes
                return "Attributes"
            } else if section == 1 { // relationships
                return "Relations"
            }
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAttribute")
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
        var color = UIColor.red
        if let property = newObject!.entity.propertiesByName[text] {
            if newObject!.value(forKey: text) != nil {
                color = UIColor.green
            }
            
            if property.isOptional {
                color = UIColor.gray
            }
        }
        cell?.textLabel?.textColor = color
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
