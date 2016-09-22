//
//  CoreDataManager.swift
//  wc2018
//
//  Created by VRS on 17/09/16.
//  Copyright © 2016 Viktor Sydorenko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: singleton
    
    static let instance = CoreDataManager()
    
    // MARK: methods
    
    func castOrCreate(entityName: String, object: AnyObject?, inout entity: ManagedObjectBase?){
        if object != nil {
            switch entityName {
            case "Country":
                entity = object as? Country
            case "Game":
                entity = object as? Game
            case "Goal":
                entity = object as? Goal
            case "Round":
                entity = object as? Round
            case "City":
                entity = object as? City
            case "GameState":
                entity = object as? GameState
            case "Team":
                entity = object as? Team
            default: break
            }
        }
        else
        {
            switch entityName {
            case "Country":
                entity = Country()
            case "Game":
                entity = Game()
            case "Goal":
                entity = Goal()
            case "Round":
                entity = Round()
            case "City":
                entity = City()
            case "GameState":
                entity = GameState()
            case "Team":
                entity = Team()
            default: break
            }
        }
    }
    
    // Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedObjectContext)!
    }
    
    func fetchedResultsController(entity: String, predicate: NSPredicate?, sorting:String?, grouping:String?) -> NSFetchedResultsController
    {
        let request = NSFetchRequest(entityName: entity)
        let sort = NSSortDescriptor(key: sorting, ascending: true)
        request.sortDescriptors = [sort]
        if predicate != nil{
            request.predicate = predicate
        }
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: grouping, cacheName: nil)
        
        return controller
    }
    
    func fetchedResultsController(entity: String, id: Int) -> NSFetchedResultsController
    {
        let predicate: NSPredicate? = NSPredicate(format: "id == %@", argumentArray: [id])
        return CoreDataManager.instance.fetchedResultsController(entity, predicate: predicate, sorting: "id", grouping: nil)
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tournamentuptodate.wc2018" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("wc2018", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}