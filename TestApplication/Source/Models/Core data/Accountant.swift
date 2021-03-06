//
//  Accountant.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class Accountant: Worker {
    @NSManaged var type: NSNumber?

    override class var entityName: String {
        return "Accountant"
    }

    override class var keys: [String] {
        var keys = super.keys
        keys.append(EmployeeAttributeKeys.accountantType)
        return keys
    }
}
