//
//  CoreDataStack.swift
//  Hogwarts
//
//  Created by Kaleb  Carrizoza on 9/17/20.
//  Copyright © 2020 Kaleb  Carrizoza. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
        //change the container name for every project
        let container = NSPersistentContainer(name: "Hogwarts")
        
        //need to access this container to complete
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext {return container.viewContext}
}//end of class
