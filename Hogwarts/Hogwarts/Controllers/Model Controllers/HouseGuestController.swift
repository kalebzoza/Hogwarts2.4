//
//  HouseGuestController.swift
//  Hogwarts
//
//  Created by Kaleb  Carrizoza on 9/17/20.
//  Copyright © 2020 Kaleb  Carrizoza. All rights reserved.
//

import Foundation
import CoreData

class HouseGuestController {
    //MARK: - Properties
    static let sharedInstance = HouseGuestController()
   
    let fetchResultsController: NSFetchedResultsController<HouseGuest> = {
        //calling the fetch function
        let fetchRequest: NSFetchRequest<HouseGuest> = HouseGuest.fetchRequest()
       //making the sort controller
        let veiledSort = NSSortDescriptor(key: "isVisible", ascending: false)
        
        //calls the sort function
        fetchRequest.sortDescriptors = [veiledSort]
        
        //this the name of the sections coming from the fetchRequest
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isVisible", cacheName: nil)
  
    
    
    }()
    
    init() {
        
        do {
            try fetchResultsController.performFetch()
        }catch{
            print(error)
        }
        
    }
    
    //MARK: -CRUD Functions
    //put what we need to create the guess
    func createGuest(guestName: String, house: String) {
        _ = HouseGuest(guestName: guestName, house: house)
       
        
        
        
        saveToPersistentStore()
    }
    
    func updateVisibility(houseGuest: HouseGuest) {
        houseGuest.isVisible = !houseGuest.isVisible
        
       saveToPersistentStore()
    }
    
    func removeGuest(houseGuest: HouseGuest) {
        let moc = CoreDataStack.context
        moc.delete(houseGuest)
    }
    
    //MARK: - Persistence
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        }catch {
            print(error)
        }
    }
}
