//
//  Functions.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Functions: NSObject {
   
}

// String
public func vString(value: AnyObject?, dateFormat: String = "dd.MM.yyyy") -> String {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    
    if let objectValue: NSDate = value as? NSDate {
        return dateFormatter.stringFromDate(objectValue)
    }
    
    if let returnValue: AnyObject = value {
        return "\(returnValue)"
    }
    
    return ""
    
}

// Integer
public func vInt(value: AnyObject?) -> Int {
    
    if let objectValue: AnyObject = value {
        if let returnValue = NSNumberFormatter().numberFromString("\(objectValue)") {
            return returnValue.integerValue
        }
    }
    
    return 0
    
}

// Double
public func vDouble(value: AnyObject?) -> Double {

    let formatter = NSNumberFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_EN")
    
    if let objectValue: AnyObject = value {
        if let returnValue = formatter.numberFromString("\(objectValue)") {
            return returnValue.doubleValue
        }
        
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        if let returnValue = formatter.numberFromString("\(objectValue)") {
            return returnValue.doubleValue
        }
    }
    return 0
    
}

// Date
public func vDate(value: AnyObject?) -> NSDate {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    
    
    if let objectValue: AnyObject = value {
        
        if let returnValue = objectValue as? NSDate {
            return returnValue
        }
        
        if let returnValue = dateFormatter.dateFromString("\(objectValue)") {
            return returnValue
        }
    }
    
    return NSDate(timeIntervalSince1970: 0)
    
}

// Boolean
public func vBool(value: AnyObject?) -> Bool {
    
    if let objectValue: AnyObject = value {
        
        if let returnValue = objectValue as? Bool {
            return returnValue
        }
        
        if let returnValue = NSNumberFormatter().numberFromString("\(objectValue)") {
            return (returnValue.integerValue == 1)
        }
        
        if "\(objectValue)".lowercaseString == "true" || "\(objectValue)".lowercaseString == "yes" {
            return true
        }
    }
    
    return false
    
}

// Get JSON Data
func getJSONData(link: String) -> NSData? {
    
    let tempPath = NSURL(string: link.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
    if let path = tempPath {
        
        if let data = NSData(contentsOfURL: path) {
            return data
        }
    }
    
    return nil
    
}








