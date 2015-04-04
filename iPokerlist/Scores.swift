//
//  Scores.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 10.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Scores: NSObject {
   
    var position: Int = 1
    var PER_ID: Int = 0
    var name: String = ""
    var chipsIn: Double = 0
    var chipsOut: Double = 0
    var ratio: Double = 0
    var games: Int = 1
    var moneyIn: Double = 0
    var moneyOut: Double = 0
    var maxWin: Double = 0
    var ratioMax: Double = 0

    var oPER: Persons = Persons()
    
    override init() {
        super.init()
    }
    
    init(PER_ID: Int, name: String, chipsIn: Double, chipsOut: Double, moneyIn: Double, moneyOut: Double, position: Int) {
        super.init()
        
        self.PER_ID = PER_ID
        self.name = name
        self.chipsIn += chipsIn
        self.chipsOut += chipsOut
        self.position = position
        self.moneyIn = moneyIn
        self.moneyOut = moneyOut
        self.position = position
        self.maxWin = (moneyOut - moneyIn)
        self.ratioMax = chipsOut / vDouble((chipsIn != 0 ? chipsIn : 1)) * 100.00

    }

    
}
