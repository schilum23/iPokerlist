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
    
    func defaultNavigationBar(title: String, viewController: UIViewController, lBTitle: String, lBFunc: String, rBTitle: String, rBFunc: String) {
        
        self.frame = CGRectMake(0, 20, viewController.view.frame.width, 44)
        self.backgroundColor = UIColor.whiteColor()
        
        var navItem = UINavigationItem()
        self.items = [navItem]
        
        var lButton = UIBarButtonItem(title: lBTitle, style: UIBarButtonItemStyle.Bordered, target: viewController, action: Selector(lBFunc))
        var rButton = UIBarButtonItem(title: rBTitle, style: UIBarButtonItemStyle.Bordered, target: viewController, action: NSSelectorFromString(rBFunc))
        
        navItem.rightBarButtonItem = rButton
        navItem.leftBarButtonItem = lButton
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
}

