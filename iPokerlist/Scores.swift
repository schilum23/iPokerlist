//
//  Scores.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 10.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Scores: NSObject {
   
    // MARK: - Variablen
    var position: Int = 1
    var lastPosition: Int = 0
    var PKL_ID: Int = 0
    var PER_ID: Int = 1
    var chipsIn: Double = 0
    var chipsOut: Double = 0
    var ratio: Double = 0
    var games: Int = 1
    var moneyIn: Double = 0
    var moneyOut: Double = 0
    var maxWin: Double = 0
    var ratioMax: Double = 0

    // MARK: - Init / Coder
    override init() {
        super.init()
    }
    
    init(coder aDecoder: NSCoder!) {
        self.position = aDecoder.decodeObjectForKey("position") as! Int
        self.lastPosition = aDecoder.decodeObjectForKey("lastPosition") as! Int
        self.PKL_ID = aDecoder.decodeObjectForKey("PKL_ID") as! Int
        self.PER_ID = aDecoder.decodeObjectForKey("PER_ID") as! Int
        self.chipsIn = aDecoder.decodeObjectForKey("chipsIn") as! Double
        self.chipsOut = aDecoder.decodeObjectForKey("chipsOut") as! Double
        self.ratio = aDecoder.decodeObjectForKey("ratio") as! Double
        self.games = aDecoder.decodeObjectForKey("games") as! Int
        self.moneyIn = aDecoder.decodeObjectForKey("moneyIn") as! Double
        self.moneyOut = aDecoder.decodeObjectForKey("moneyOut") as! Double
        self.maxWin = aDecoder.decodeObjectForKey("maxWin") as! Double
        self.ratioMax = aDecoder.decodeObjectForKey("ratioMax") as! Double
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(position, forKey: "position")
        aCoder.encodeObject(lastPosition, forKey: "lastPosition")
        aCoder.encodeObject(PKL_ID, forKey: "PKL_ID")
        aCoder.encodeObject(PER_ID, forKey: "PER_ID")
        aCoder.encodeObject(chipsIn, forKey: "chipsIn")
        aCoder.encodeObject(chipsOut, forKey: "chipsOut")
        aCoder.encodeObject(ratio, forKey: "ratio")
        aCoder.encodeObject(games, forKey: "games")
        aCoder.encodeObject(moneyIn, forKey: "moneyIn")
        aCoder.encodeObject(moneyOut, forKey: "moneyOut")
        aCoder.encodeObject(maxWin, forKey: "maxWin")
        aCoder.encodeObject(ratioMax, forKey: "ratioMax")
    }
    
    init(PER_ID: Int, chipsIn: Double, chipsOut: Double, moneyIn: Double, moneyOut: Double, position: Int) {
        super.init()
        
        self.PER_ID = PER_ID
        self.chipsIn += chipsIn
        self.chipsOut += chipsOut
        self.position = position
        self.moneyIn = moneyIn
        self.moneyOut = moneyOut
        self.position = position
        self.maxWin = (moneyOut - moneyIn)
        self.ratioMax = chipsOut / vDouble((chipsIn != 0 ? chipsIn : 1)) * 100.00

    }
    
    func linkedPerson(arrayPersons: [Persons]) -> Persons? {
        return arrayPersons.filter( { $0.id == self.PER_ID } ).first
    }
    
}
