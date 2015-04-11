//
//  Extensions.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Extensions: NSObject {
   
}

// Default Navigation Bar
public extension UINavigationBar {
    
    func defaultNavigationBar(title: String, viewController: UIViewController, lBTitle: String, lBFunc: String, rBTitle: String?=nil, rBFunc: String?=nil) {
        
        self.frame = CGRectMake(0, 20, viewController.view.frame.width, 44)
        self.backgroundColor = UIColor.whiteColor()
        
        var navItem = UINavigationItem()
        self.items = [navItem]
        
        var lButton = UIBarButtonItem(title: lBTitle, style: UIBarButtonItemStyle.Plain, target: viewController, action: Selector(lBFunc))
        navItem.leftBarButtonItem = lButton


        if rBTitle != nil && rBFunc != nil {
            var rButton = UIBarButtonItem(title: rBTitle!, style: UIBarButtonItemStyle.Plain, target: viewController, action: NSSelectorFromString(rBFunc!))
            navItem.rightBarButtonItem = rButton
        }
        
        navItem.title = title
        
    }
    
}

// Alle Subviews einer View entfernen
public extension UIView {
    
    func removeSubViews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func iUITextFieldWithNumber(number: Int) -> UIView? {
        for subView in self.subviews {
            if let textField = subView as? iUITextField {
                if textField.number == number {
                    return textField
                }
            }
        }
        return nil
    }
}
