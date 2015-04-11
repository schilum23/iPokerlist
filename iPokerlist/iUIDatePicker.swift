//
//  iUIDatePicker.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

protocol iUIDatePickerDelegate {
    func resizeView(height: CGFloat)
}

class iUIDatePicker: UIView {
    
    var iDatePickerDelegate: iUIDatePickerDelegate?
    var dateButton = UIButton()
    var datePicker = UIDatePicker()
    let dateButtonHeight: CGFloat = 36.00
    let datePickerHeight: CGFloat = 200
    var viewSize: CGFloat = 0
    var date = NSDate()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSize = datePickerHeight + dateButtonHeight
        self.frame.size.height = viewSize
        
        // Date Button
        dateButton = UIButton(frame: CGRectMake(0, 0, frame.width, dateButtonHeight))
        dateButton.setTitle("Datum: \(vString(datePicker.date))", forState: UIControlState.Normal)
        dateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        dateButton.addTarget(self, action: "dateButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(dateButton)
        
        // DatePicker
        datePicker = UIDatePicker(frame: CGRectMake(0, CGRectGetMaxY(dateButton.frame), frame.width, datePickerHeight))
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.locale = NSLocale(localeIdentifier: "de_DE")
        datePicker.hidden = true
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(datePicker)
        
    }
    
    func dateButtonAction(button: UIButton) {
        datePicker.hidden = !(datePicker.hidden)
        iDatePickerDelegate?.resizeView(!(datePicker.hidden) ? dateButtonHeight + datePickerHeight : dateButtonHeight)
    }
    
    func resizeView() {
        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        date = self.datePicker.date
        self.dateButton.setTitle("Datum: \(vString(self.datePicker.date))", forState: UIControlState.Normal)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

