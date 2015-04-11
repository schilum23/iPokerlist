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
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Statistik"
        
        if let oPER: Persons = self.data.arrayPersons.filter( { $0.id == self.PER_ID } ).first {
            let header = (year == 0) ? "Gesamt" : vString(year)
            title = "Statistik \(oPER.name) \(header)"
        }
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "Zurück", lBFunc: "backButtonAction:")
        self.view.addSubview(navBar)
        
        // Position
        let labelPos = UILabel(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame) + 10, self.view.frame.width, 34))
        labelPos.font = UIFont.boldSystemFontOfSize(20.0)
        labelPos.textAlignment = .Center
        labelPos.text = "Position: \(oSCO!.position)"
        self.view.addSubview(labelPos)
        
        
        // Spiele
        let labelGames = UILabel(frame: CGRectMake(0, CGRectGetMaxY(labelPos.frame), self.view.frame.width, 20))
        labelGames.font = UIFont.boldSystemFontOfSize(16.0)
        labelGames.textAlignment = .Center
        labelGames.text = "Spiele: \(oSCO!.games)"
        self.view.addSubview(labelGames)
        
        // Verhältnis
        let labelRatio = UILabel(frame: CGRectMake(0, CGRectGetMaxY(labelGames.frame), self.view.frame.width, 34))
        labelRatio.textAlignment = .Center
        let ratio = String(format: "%.2f", vDouble(oSCO?.ratio))
        let win = String(format: "%.2f", vDouble(oSCO!.moneyOut-oSCO!.moneyIn))
        labelRatio.text = "Verhältnis: \(ratio)%      G/V: \(win)€"
        self.view.addSubview(labelRatio)
        
        // Ein/Aus
        let labelInOut = UILabel(frame: CGRectMake(0, CGRectGetMaxY(labelRatio.frame), self.view.frame.width, 34))
        labelInOut.textAlignment = .Center
        let valueIn = String(format: "%.2f", vDouble(oSCO?.moneyIn))
        let valueOut = String(format: "%.2f", vDouble(oSCO!.moneyOut))
        labelInOut.text = "Ein: \(valueIn)€      Aus: \(valueOut)€"
        self.view.addSubview(labelInOut)


        
    }
    
    // MARK: - BarButton Events
    // Zurück
    func backButtonAction(button: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}