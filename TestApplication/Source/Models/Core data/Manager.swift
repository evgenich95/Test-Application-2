//
//  Manager.swift
//  TestApplication
//
//  Created by developer on 07.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData


class Manager: Person {
    @NSManaged var startVisitingHours: NSDate?
    @NSManaged var endVisitingHours: NSDate?

    override class var entityName: String {
        return "Manager"
    }

    override class var keys: [String] {
        var keys = super.keys
        keys.append(PersonAttributeKeys.startVisitingHours)
        keys.append(PersonAttributeKeys.endVisitingHours)
        return keys
    }

//    override var attributeDictionary: [String : AnyObject] {
//        var attributeDictionary = super.attributeDictionary
//
//        attributeDictionary[PersonAttributeKeys.startVisitingHours] = startVisitingHours
//        attributeDictionary[PersonAttributeKeys.endVisitingHours] = endVisitingHours
//
//        return attributeDictionary
//    }
}
