//
//  Item+CoreDataClass.swift
//  s05DreamLister
//
//  Created by bernadette on 2/10/17.
//  Copyright © 2017 Bernadette P. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    // Timestamp
    // ... when it's inserted into the object context
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        // ...assign the current date to the attribute created (in 'Item' entity, is the attribute 'created' of type Date)
        self.created = NSDate()
    }
    
}
