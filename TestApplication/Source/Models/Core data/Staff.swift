//
//  Staff.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData


class Staff: Person {
    @NSManaged var workplaceNumber: NSNumber?
    @NSManaged var startMealTime: NSDate?
    @NSManaged var endMealTime: NSDate?

    override class var entityName: String {
        return "Staff"
    }
}
