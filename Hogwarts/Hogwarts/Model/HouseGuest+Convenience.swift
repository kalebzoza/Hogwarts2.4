//
//  HouseGuest+Convenience.swift
//  Hogwarts
//
//  Created by Kaleb  Carrizoza on 9/17/20.
//  Copyright © 2020 Kaleb  Carrizoza. All rights reserved.
//

import Foundation
import CoreData


extension HouseGuest {
    
    convenience init(guestName: String, house: String, isVisible: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.guestName = guestName
        self.house = house
        self.isVisible = isVisible
        
    }
}
