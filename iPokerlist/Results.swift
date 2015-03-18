//
//  Results.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit


class Results: NSObject {
    
    var id: Int = 0
    var created: NSDate = NSDate()
    var changed: NSDate = NSDate()
    var deleted: NSDate?
    var PKL_ID: Int = 1
    var PER_ID: Int = 1
    var state: Int = 1
    var name: String = ""
    var date: NSDate!
    var year: String = ""
    var dateString: String = ""
    var chipsIn: Double = 0
    var chipsOut: Double = 0
    var chipsWin: Double = 0
    var factor: Double = 1
    var moneyIn: Double = 0
    var moneyOut: Double = 0
    var moneyWin: Double = 0
    var ratio: Double = 0
    var error: NSError?
    
    override init() {
        super.init()
    }
    
    init(date: NSDate) {
        super.init()
        
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let components = NSCalendar.currentCalendar().components(flags, fromDate: vDate(date))
        
        self.dateString = vString(date)
        self.date = vDate(date)
        self.year = vString(components.year)
    }
    
    init(wsData: [String:NSObject]) {
        super.init()
        
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let components = NSCalendar.currentCalendar().components(flags, fromDate: vDate(wsData["date"]))
        
        self.id = vInt(wsData["id"])
        self.created = vDate(wsData["created"])
        self.changed = vDate(wsData["changed"])
        self.deleted = vDate(wsData["Deleted"])
        self.PKL_ID = vInt(wsData["RES_PKL"])
        self.PER_ID = vInt(wsData["PER_ID"])
        self.name = vString(wsData["name"])
        self.dateString = vString(wsData["date"])
        self.date = vDate(wsData["date"])
        self.year = vString(components.year)
        self.chipsIn = vDouble(wsData["chipsIn"])
        self.chipsOut = vDouble(wsData["chipsOut"])
        self.factor = vDouble(wsData["factor"])
        
        // Status 0 = von Webservice
        self.state = 0
        
        // Gewinn, Verhätlnis und Geld
        self.chipsWin = self.chipsOut - self.chipsIn
        self.moneyIn = (self.chipsIn/100.00) * self.factor
        self.moneyOut = (self.chipsOut/100.00) * self.factor
        self.moneyWin = self.moneyOut - self.moneyIn
        
        self.ratio = (self.chipsIn > 0) ? (self.chipsOut / self.chipsIn) * 100 : 0
    }
    
    func addResultWS() {
        
        let dateFormat = "yyyyMMdd"
        let dateFormatCreated = "yyyyMMdd HH:mm:ss"

        let link = "http://217.160.178.136/Service.asmx/addResult?RES_PER=" +
        "\(self.PER_ID)&RES_PKL=\(self.PKL_ID)&RES_Date=\(vString(self.date, dateFormat: dateFormat))&RES_In=\(self.chipsIn)&RES_Out=\(self.chipsOut)&RES_Created=\(vString(self.created, dateFormat: dateFormatCreated))"

        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as [[String:NSObject]]
        } else {
            println("ERROR: Keine Daten")
        }
        
        if self.error == nil {
            println("Kein Fehler")
        } else {
            println("Fehler")
        }
        
    }
    
    
}


















