//
//  CoreDataManager.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import CoreData

class CoreDataManager: NSObject {

    let stack = CoreDataStack(modelName: CoreDataStack.Constants.ModelName)!
    
    // MARK: Pin
    
    func storePin(latitude:Double, longitude:Double) -> Pin? {
        
        if let pin = NSEntityDescription.insertNewObject(forEntityName: CoreDataStack.Constants.Entity.Pin, into: stack.context) as? Pin {
            
            pin.latitude = latitude
            pin.longitude = longitude
            
            do {
                try stack.saveContext()
            } catch {
                fatalError("Error occured while saving Pin")
            }
            
            return pin
        }
        
        return nil
    }
    
    func storePhoto(using photoDictionary:[String:AnyObject], pin:Pin) {
        
        if let photo = NSEntityDescription.insertNewObject(forEntityName: CoreDataStack.Constants.Entity.Photo, into: stack.context) as? Photo {
            
            photo.pin = pin
            photo.imageURL = photoDictionary[FlickrClient.ResponseKeys.MediumURL] as? String ?? ""
            photo.createdAt = NSDate()
            
            do {
                try stack.saveContext()
            } catch {
                fatalError("Error occured while saving Photo")
            }
        }
    }
    
    func storePhotos(using photosArray:[[String:AnyObject]], pin:Pin) {
        for photoDictionary in photosArray {
            storePhoto(using: photoDictionary, pin: pin)
        }
    }
    
    func getPins() -> [Pin] {
        
        let fetchRequest = NSFetchRequest<Pin>(entityName: CoreDataStack.Constants.Entity.Pin)
        var pinsArray = [Pin]()
        
        do {
           pinsArray = try stack.context.fetch(fetchRequest)
        } catch {
            fatalError("Error occured while fetching Pins")
        }
        
        return pinsArray
    }
    
    func getPhoto(of pin:Pin) -> [Photo] {
        
        let fetchRequest = NSFetchRequest<Photo>(entityName: CoreDataStack.Constants.Entity.Photo)
        fetchRequest.predicate = NSPredicate(format: "pin = %@", pin)
        
        var photosArray = [Photo]()
        
        do {
            photosArray = try stack.context.fetch(fetchRequest)
        } catch {
            fatalError("Error occured while fetching Photos")
        }
        
        return photosArray
    }
    
    func getFetchRequestControllerForPhotos(pin:Pin) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataStack.Constants.Entity.Photo)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: CoreDataStack.Constants.Attribute.CreatedAt, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "pin = %@", pin)

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: CoreDataStack.Constants.Attribute.CreatedAt, cacheName: nil)
        return fetchedResultsController
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
