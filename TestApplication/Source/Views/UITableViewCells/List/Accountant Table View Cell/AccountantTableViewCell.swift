//
//  AccountantTableViewswift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class AccountantTableViewCell: UITableViewCell {

    @IBOutlet weak internal var fullNameLabel: UILabel!

    @IBOutlet weak internal var salaryLabel: UILabel!

    @IBOutlet weak internal var workplaeNumberLabel: UILabel!

    @IBOutlet weak internal var mealTimeLabel: UILabel!

    @IBOutlet weak var accountantTypeLabel: UILabel!

    func updateUI(accountant: Accountant) {
        fullNameLabel.text = accountant.fullName
        salaryLabel.text = accountant.salary?.stringValue

        switch (accountant.startMealTime?.timeString,
                accountant.endMealTime?.timeString) {
        case let (fromTime?, toTime?):
            mealTimeLabel.text = "From \(fromTime) to \(toTime)"
        default: break
        }

        workplaeNumberLabel.text = accountant.workplaceNumber?.stringValue

        guard let
            possibleValues = EmployeeAttribute.AccountantType
                .possibleValues,
            idx = accountant.type?.integerValue,
            text = possibleValues[idx] as? String
        else {fatalError()}
        accountantTypeLabel.text = text
    }
}
