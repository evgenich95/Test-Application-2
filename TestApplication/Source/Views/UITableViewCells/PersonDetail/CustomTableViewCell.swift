//
//  CustomTableViewCell.swift
//  TestApplication
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

protocol DelegateForCustomCell {
    func cellBeginEditing()
    func cellDidEndEditing()
}

class CustomTableViewCell: UITableViewCell {

    var delegate: DelegateForCustomCell?
    private var actionForClearField: (() -> Void)?

    //MARK: Parameters
    var inputDataType: NSAttributeType? {
        willSet {
            if let type = newValue {
                dataTextField.keyboardType = appropriateKeyboardType(type)
            }
        }
    }

    var attributeDescriptionString: [String]? {
        willSet {
            switch (newValue?[0], newValue?[1]) {
            case let (description, placeholder):
                self.descriptionLabel.text = description
                self.dataTextField.placeholder = placeholder
            }
        }
    }

    var attributeValueString: AnyObject? {
        willSet {
            if let text = newValue as? String {
                self.dataTextField.text = text
            }
            
            if let text = newValue as? NSNumber {
                self.dataTextField.text = text.stringValue
            }
        }
    }
    var dataTextFieldInputView: UIView? {
        willSet {
            dataTextField.inputView = newValue
        }
    }

    //MARK: Lazy Parameters

    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.6
        label.textAlignment = .Right
        self.addSubview(label)
        return label
    }()

    lazy private var dataTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .Right
        textField.delegate = self
        textField.minimumFontSize = 7
        textField.returnKeyType = .Done
        let separatedView = UIView()
        separatedView.bounds.size = (CGSize(width: 2, height: 2))
        separatedView.backgroundColor = UIColor.grayColor()
        textField.inputAccessoryView = separatedView
        textField.addTarget(
            self,
            action: #selector(textFieldValueChange),
            forControlEvents: .EditingChanged)

        self.addSubview(textField)
        return textField
    }()

    //MARK:-

    init(inputDataType: NSAttributeType = .StringAttributeType,
         actionForClearField: () -> Void) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)

        defer {
            self.inputDataType = inputDataType
        }
        self.actionForClearField = actionForClearField
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: addTargert's functions

    @objc private func textFieldValueChange() {
        if dataTextField.text?.characters.count < 1 {
            actionForClearField?()
        }
    }

    //MARK: Help functions

    private func appropriateKeyboardType (inputDataType: NSAttributeType) -> UIKeyboardType {
        switch inputDataType {
        case .StringAttributeType:
            return UIKeyboardType.Default
        case .DecimalAttributeType,
             .DoubleAttributeType,
             .FloatAttributeType:
            return UIKeyboardType.DecimalPad
        case .Integer32AttributeType:
            return UIKeyboardType.NumberPad
        default:
            return UIKeyboardType.Default
        }
    }

    private func configureView() {
        descriptionLabel.snp_makeConstraints { (make) -> Void in
            make.leading.top.equalTo(self).offset(8)
            make.centerY.equalTo(self)
            // 40% from cell.width
            make.width.equalTo(self.snp_width).multipliedBy(0.4)
        }

        dataTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(8)
            make.trailing.equalTo(self).inset(8)
            make.centerY.equalTo(self)
            // 60% from cell.width
            make.left.equalTo(descriptionLabel.snp_right).offset(8)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
}

//MARK:-
//MARK: Extensions
//MARK:-

extension CustomTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.cellDidEndEditing()
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.cellBeginEditing()
    }
}
