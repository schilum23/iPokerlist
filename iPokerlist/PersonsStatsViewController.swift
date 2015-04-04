//
//  PersonsStatsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 25.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class PersonsStatsViewController: UIViewController {

    var data: Data!
    var year: Int = 0
    var PER_ID: Int = 0
    var oSCO: Scores?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        println(oSCO?.maxWin)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Statistik"
        
        if let oPER: Persons = self.data.arrayPersons.filter( { $0.id == self.PER_ID } ).first? {
            let header = (year == 0) ? "Gesamt" : vString(year)
            title = "Statistik \(oPER.name) \(header)"
        }
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "Zurück", lBFunc: "backButtonAction:")
        self.view.addSubview(navBar)
        
    }
    
    // MARK: - BarButton Events
    // Zurück
    func backButtonAction(button: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}