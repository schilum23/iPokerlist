//
//  SettingsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 25.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var data: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        data.changed = false
        setupViews()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Einstellungen"
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "back", lBFunc: "backButtonAction:")
        self.view.addSubview(navBar)
        
        // TEMP Switcher
        let switcher = UISwitch(frame: CGRectMake(10, CGRectGetMaxY(navBar.frame) + 10, 0, 0))
        switcher.addTarget(self, action: "stateChanged:", forControlEvents: .ValueChanged)
        switcher.on = self.data.rightToChangeData
        self.view.addSubview(switcher)
        
    }
    
    func stateChanged(switcher: UISwitch) {
        //self.data.rightToChangeData = switcher.on
        self.data.changed = true
        
        self.data.getPersonUpdatesFromWS()
        self.data.lastUpdate = NSDate()
        self.data.getResultsUpdatesFromWS()
        
    }

    // MARK: - BarButton Events
    // Zurück
    func backButtonAction(button: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
