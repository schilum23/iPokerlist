//
//  Results.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit


class Results: NSObject {
    
    // MARK: - Variablen
    var id: Int = 0
    var created: NSDate = NSDate()
    var changed: NSDate = NSDate()
    var deleted: NSDate?
    var PKL_ID: Int = 1
    var PER_ID: Int = 1
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
    
    // MARK: - Init / Coder
    override init() {
        super.init()
    }
    
    init(coder aDecoder: NSCoder!) {
        self.id = aDecoder.decodeObjectForKey("id") as! Int
        self.created = aDecoder.decodeObjectForKey("created") as! NSDate
        self.changed = aDecoder.decodeObjectForKey("changed") as! NSDate
        self.deleted = aDecoder.decodeObjectForKey("deleted") as? NSDate
        self.PKL_ID = aDecoder.decodeObjectForKey("PKL_ID") as! Int
        self.PER_ID = aDecoder.decodeObjectForKey("PER_ID") as! Int
        self.date = aDecoder.decodeObjectForKey("date") as! NSDate
        self.year = aDecoder.decodeObjectForKey("year") as! String
        self.dateString = aDecoder.decodeObjectForKey("dateString") as! String
        self.chipsIn = aDecoder.decodeObjectForKey("chipsIn") as! Double
        self.chipsOut = aDecoder.decodeObjectForKey("chipsOut") as! Double
        self.chipsWin = aDecoder.decodeObjectForKey("chipsWin") as! Double
        self.factor = aDecoder.decodeObjectForKey("factor") as! Double
        self.moneyIn = aDecoder.decodeObjectForKey("moneyIn") as! Double
        self.moneyOut = aDecoder.decodeObjectForKey("moneyOut") as! Double
        self.moneyWin = aDecoder.decodeObjectForKey("moneyWin") as! Double
        self.ratio = aDecoder.decodeObjectForKey("ratio") as! Double
        self.error = aDecoder.decodeObjectForKey("error") as? NSError
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(created, forKey: "created")
        aCoder.encodeObject(changed, forKey: "changed")
        aCoder.encodeObject(deleted, forKey: "deleted")
        aCoder.encodeObject(PKL_ID, forKey: "PKL_ID")
        aCoder.encodeObject(PER_ID, forKey: "PER_ID")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(year, forKey: "year")
        aCoder.encodeObject(dateString, forKey: "dateString")
        aCoder.encodeObject(chipsIn, forKey: "chipsIn")
        aCoder.encodeObject(chipsOut, forKey: "chipsOut")
        aCoder.encodeObject(chipsWin, forKey: "chipsWin")
        aCoder.encodeObject(factor, forKey: "factor")
        aCoder.encodeObject(moneyIn, forKey: "moneyIn")
        aCoder.encodeObject(moneyOut, forKey: "moneyOut")
        aCoder.encodeObject(moneyWin, forKey: "moneyWin")
        aCoder.encodeObject(ratio, forKey: "ratio")
        aCoder.encodeObject(error, forKey: "error")
    }

    
    init(date: NSDate) {
        super.init()
        
        let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear
        let components = NSCalendar.currentCalendar().components(flags, fromDate: vDate(date))
        
        self.dateString = vString(date)
        self.date = vDate(date)
        self.year = vString(components.year)
    }
    
    init(wsData: [String:NSObject]) {
        super.init()
        
        let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear
        let components = NSCalendar.currentCalendar().components(flags, fromDate: vDate(wsData["date"]))
        
        self.id = vInt(wsData["id"])
        self.created = vDate(wsData["created"])
        self.changed = vDate(wsData["changed"])
        self.deleted = vDate(wsData["Deleted"])
        self.PKL_ID = vInt(wsData["RES_PKL"])
        self.PER_ID = vInt(wsData["PER_ID"])
        self.dateString = vString(wsData["date"])
        self.date = vDate(wsData["date"])
        self.year = vString(components.year)
        self.chipsIn = vDouble(wsData["chipsIn"])
        self.chipsOut = vDouble(wsData["chipsOut"])
        self.factor = vDouble(wsData["factor"])
        
        calculateData()
        
    }
    
    func calculateData() {
        
        // Gewinn, Verhätlnis und Geld
        self.chipsWin = self.chipsOut - self.chipsIn
        self.moneyIn = (self.chipsIn/100.00) * self.factor
        self.moneyOut = (self.chipsOut/100.00) * self.factor
        self.moneyWin = self.moneyOut - self.moneyIn
        
        self.ratio = (self.chipsIn > 0) ? (self.chipsOut / self.chipsIn) * 100 : 0
    }
    
    func linkedPerson(arrayPersons: [Persons]) -> Persons? {
        return arrayPersons.filter( { $0.id == self.PER_ID } ).first
    }
    
    func addResultWS() -> Int {
        
        let dateFormat = "yyyyMMdd"
        let dateFormatCreated = "yyyyMMdd HH:mm:ss"

        let link = "http://217.160.178.136/Service.asmx/addResult?RES_PER=" +
        "\(self.PER_ID)&RES_PKL=\(self.PKL_ID)&RES_Date=\(vString(self.date, dateFormat: dateFormat))&RES_In=\(self.chipsIn)&RES_Out=\(self.chipsOut)&RES_Created=\(vString(self.created, dateFormat: dateFormatCreated))"

        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as! [[String:NSObject]]
            if error != nil {
                println("ERROR: Fehler beim hinzufügen einer Person. \(error!.description)")
            }
            return vInt(tempError[0]["id"])
        }
        return 0
    }
    
    func deleteResultWS() -> Bool {
        
        let dateFormat = "yyyyMMdd HH:mm:ss"
        
        let link = "http://217.160.178.136/Service.asmx/updateResult?RES_ID=\(self.id)&RES_Deleted=\(vString(self.deleted, dateFormat: dateFormat))" +
        "&RES_Changed=\(vString(self.changed, dateFormat: dateFormat))&RES_In=\(vDouble(self.chipsIn))&RES_Out=\(vDouble(self.chipsOut))"
        
        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as! [[String:NSObject]]
            if error != nil {
                println("ERROR: Fehler beim löschen eines Resultates. \(error!.description)")
            }
            return (self.error == nil)
        }
        return false
        
    }
    
    func updateResultWS() -> Bool {
        
        let dateFormat = "yyyyMMdd HH:mm:ss"
        
        let link = "http://217.160.178.136/Service.asmx/updateResult?RES_ID=\(self.id)&RES_Deleted=" +
        "&RES_Changed=\(vString(self.changed, dateFormat: dateFormat))&RES_In=\(vDouble(self.chipsIn))&RES_Out=\(vDouble(self.chipsOut))"
        
        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as! [[String:NSObject]]
            if error != nil {
                println("ERROR: Fehler beim löschen eines Resultates. \(error!.description)")
            }
            return (self.error == nil)
        }
        return false
    }
    
}


















