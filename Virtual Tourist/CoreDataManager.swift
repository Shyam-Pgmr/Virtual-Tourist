//
//  CoreDataManager.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import CoreData

class CoreDataManager: NSObject {

    private let stack = CoreDataStack(modelName: CoreDataStack.Constants.ModelName)!
    
    // MARK: Pin
    
    func storePin(latitude:Double, longitude:Double) {
        
        if let pin = NSEntityDescription.insertNewObject(forEntityName: CoreDataStack.Constants.Entity.Pin, into: stack.context) as? Pin {
            
            pin.latitude = latitude
            pin.longitude = longitude
            
            do {
                try stack.saveContext()
            } catch {
                fatalError("Error occured while saving Pin")
            }
        }
    }
    
    // MARK: Helpers
    
    // Shared Instance
    class func shard() -> CoreDataManager {
        
        struct Singleton {
            static let sharedInstance = CoreDataManager()
        }
        return Singleton.sharedInstance
    }
}