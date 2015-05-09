//
//  Data.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit
import CoreData

let link = "http://217.160.178.136/Service.asmx/"
let wsLinkPersons = "getPersons"
let wsLinkResults = "pokerlisteResults"
let wsLists = ""

class Data: NSObject {
    
    // MARK: - Variablen
    var arrayResults = [Results]()
    var arrayGroupedResults = [[Results]]()
    var arrayPersons = [Persons]()
    var arrayScores = [Scores]()
    var arrayGroupedScores = [ScoreGroups]()
    var changed = false
    var PKL_ID = 1 //NSUserDefaults.standardUserDefaults().integerForKey("PKL_ID")
    var rightToChangeData = true
    var error: NSError?
    var dataTemp: Data?
    var lastUpdate: NSDate?
    
    // MARK: - Init / Coder
    override init() {
        super.init()
        
        if getDataFromCoreData() == nil {
            getAllData()
            saveDataToCoreData()
            self.dataTemp = self
        }
    }
    
    init(coder aDecoder: NSCoder!) {
        self.arrayResults = aDecoder.decodeObjectForKey("arrayResults") as! [Results]
        self.arrayGroupedResults = aDecoder.decodeObjectForKey("arrayGroupedResults") as! [[Results]]
        self.arrayPersons = aDecoder.decodeObjectForKey("arrayPersons") as! [Persons]
        self.arrayScores = aDecoder.decodeObjectForKey("arrayScores") as! [Scores]
        self.arrayGroupedScores = aDecoder.decodeObjectForKey("arrayGroupedScores") as! [ScoreGroups]
        self.changed = aDecoder.decodeObjectForKey("changed") as! Bool
        self.PKL_ID = aDecoder.decodeObjectForKey("PKL_ID") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(arrayResults, forKey: "arrayResults")
        aCoder.encodeObject(arrayGroupedResults, forKey: "arrayGroupedResults")
        aCoder.encodeObject(arrayPersons as NSObject, forKey: "arrayPersons")
        aCoder.encodeObject(arrayScores, forKey: "arrayScores")
        aCoder.encodeObject(arrayGroupedScores, forKey: "arrayGroupedScores")
        aCoder.encodeObject(changed, forKey: "changed")
        aCoder.encodeObject(PKL_ID, forKey: "PKL_ID")
    }
    
    // MARK: - Coredata
    // Daten in die Datenbank speichern
    func saveDataToCoreData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("CDData", inManagedObjectContext: managedContext)
        
        if let temp: NSManagedObject = getDataFromCoreData() {
            temp.setValue(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: "cdData")
        } else {
            let newData = CDData(entity: entity!, insertIntoManagedObjectContext:managedContext)
            let saveData: NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
            newData.cdData = saveData
            newData.pkl_ID = PKL_ID
        }

        if !managedContext.save(&error) {
            println("ERROR: Speichern in CoreData nicht möglich \(error), \(error?.userInfo)")
        }
    }
    
    // Daten aus der Datenbank laden
    func getDataFromCoreData() -> NSManagedObject? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entityForName("CDData", inManagedObjectContext: managedContext)!
        
        fetchRequest.entity = entetyDescription
        fetchRequest.predicate = NSPredicate(format: "pkl_ID = \(self.PKL_ID)")

        fetchRequest.returnsObjectsAsFaults = false
        var error: NSError?
        
        if let result: [NSManagedObject]? = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject] {
            
            if result?.count == 0 {
                return nil
            }
            
            let dataObject: NSManagedObject = result![0]
            
            if let nsData = dataObject.valueForKey("cdData") as? NSData {
                self.dataTemp = NSKeyedUnarchiver.unarchiveObjectWithData(nsData) as? Data
                return dataObject
            }
        }
        return nil
    }
    
    // Updates holen
    func getUpdates() -> Bool {
        
//        var newData = false
//        
//        // Personen
//        let wsPersons = getDictionary(wsLinkPersons, PKL_ID: PKL_ID)
//        
//        for dic in wsPersons {
//            
//            if let oPER: Persons = self.arrayPersons.filter( { $0.id == vInt(dic["id"]) } ).first {
//                
//                if oPER.changed != vDate(dic["changed"]) {
//                    
//                }
//                
//            } else if 1 == 1 {
//                
//            }
//            self.id = vInt(wsData["id"])
//            self.created = vDate(wsData["created"])
//            self.changed = vDate(wsData["changed"])
//            self.deleted = vDate(wsData["Deleted"])
//            self.PKL_ID = vInt(wsData["PKL_ID"])
//            self.name = vString(wsData["name"])
//            
//            var newPerson: Persons = Persons(wsData: dic)
//            arrayPersons.append(newPerson)
//        }
//        
//        // Resultate
//        let wsResults = getDictionary(wsLinkResults, PKL_ID: PKL_ID)
//        
//        for dic in wsResults {
//            var newResult: Results = Results(wsData: dic)
//            arrayResults.append(newResult)
//        }
//        
//        // Nach Datum gruppieren
//        groupBydate(TempDaten: arrayResults)
//        
//        calculateScore()
//        calculateGroupedScores()
//        sortArrayResults()
//
        return false
    }
    
    // Alle Daten beim erstmaligen hinzufügen laden
    func getAllData() {
        
        // Personen
        let wsPersons = getDictionary(wsLinkPersons, PKL_ID: PKL_ID)
        
        for dic in wsPersons {
            var newPerson: Persons = Persons(wsData: dic)
            arrayPersons.append(newPerson)
        }
        
        // Resultate
        let wsResults = getDictionary(wsLinkResults, PKL_ID: PKL_ID)
        
        for dic in wsResults {
            var newResult: Results = Results(wsData: dic)
            arrayResults.append(newResult)
        }
        
        // Nach Datum gruppieren
        groupBydate(TempDaten: arrayResults)
        
        calculateScore()
        calculateGroupedScores()
        sortArrayResults()
    }
    
    // MARK: - Personen Funktionen
    // Personen Array sortieren
    func sortArrayPersons() {
        self.arrayPersons.sort( {$0.name.lowercaseString < $1.name.lowercaseString})
    }
    
    // Person als ICH markieren
    func setPersonToMe(index: Int, setMe: Bool) {
        
        for oPER in self.arrayPersons {
           oPER.me = false
        }
        
        self.arrayPersons[index].me = setMe

        self.changed = true
        
        saveDataToCoreData()
    }
    
    // Person hinzufügen
    func addPerson(name: String) {
        
        let oPER = Persons(name: name)
        self.arrayPersons.append(oPER)
        self.sortArrayPersons()
        self.changed = true
        
        // THREAD!!!!
        if oPER.addPersonWS() {
            oPER.state = 1
        }
        saveDataToCoreData()
    }
    
    // Person bearbeiten
    func updatePerson(index: Int, name: String) {

        self.arrayPersons[index].name = name
        self.arrayPersons[index].changed = NSDate()
        self.sortArrayPersons()
        self.changed = true
        
        // THREAD!!!!
        if self.arrayPersons[index].updatePersonWS() {
            self.arrayPersons[index].state = 1
        }
        saveDataToCoreData()
    }
    
    // Person ausblenden
    func hidePerson(index: Int, setVisible: Bool) {
        
        self.arrayPersons[index].visible = setVisible
        self.arrayPersons[index].changed = NSDate()
        self.changed = true
        
        calculateScore()
        calculateGroupedScores()
        saveDataToCoreData()
    }
    
    // Person löschen
    func deletePerson(index: Int) {
        
        self.arrayPersons[index].deleted = NSDate()
        self.arrayPersons[index].changed = NSDate()
        self.changed = true

        // THREAD!!!!
        if self.arrayPersons[index].deletePersonWS() {
            self.arrayPersons[index].state = 1
        }
        
        for i in reverse(0..<self.arrayResults.count) {
            if self.arrayResults[i].PER_ID == self.arrayPersons[index].id {
                self.arrayResults.removeAtIndex(i)
            }
        }
        
        self.arrayPersons.removeAtIndex(index)
        groupBydate(TempDaten: self.arrayResults)
        calculateScore()
        calculateGroupedScores()
        self.saveDataToCoreData()
    }

    // Ergebnisse Array sortieren
    func sortArrayResults() {
        self.arrayResults.sort( { $0.date == $1.date ? $0.PER_ID < $1.PER_ID : $0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow })
    }
    
    // Ergbnis löschen
    func deleteResult(oRES: Results) {
        
        oRES.deleted = NSDate()
        oRES.changed = NSDate()
        self.changed = true
        
        // THREAD!!!!
        if oRES.deleteResultWS() {
            oRES.state = 1
        }

        //self.arrayResults.removeAtIndex(index)
        groupBydate(TempDaten: self.arrayResults)
        calculateScore()
        calculateGroupedScores()
        self.saveDataToCoreData()
    }

    
    // Ergebnis hinzufügen
    func addResult(date: NSDate, PER_ID: Int, chipsIn: String, chipsOut: String) {
        
        let oRES = Results(date: date)
        oRES.PKL_ID = self.PKL_ID
        oRES.PER_ID = PER_ID
        oRES.chipsIn = vDouble(chipsIn)
        oRES.chipsOut = vDouble(chipsOut)
        
        oRES.chipsWin = oRES.chipsOut - oRES.chipsIn
        oRES.moneyIn = (oRES.chipsIn/100.00) * oRES.factor
        oRES.moneyOut = (oRES.chipsOut/100.00) * oRES.factor
        oRES.moneyWin = oRES.moneyOut - oRES.moneyIn
        oRES.ratio = (oRES.chipsIn > 0) ? (oRES.chipsOut / oRES.chipsIn) * 100 : 0
        
        self.arrayResults.append(oRES)
        
        if oRES.addResultWS() {
            oRES.state = 1
        }
    }
    
    // Ergebnis bearbeiten
    func updateResult(oRES: Results, chipsIn: String, chipsOut: String) {

        oRES.changed = NSDate()
        oRES.chipsIn = vDouble(chipsIn)
        oRES.chipsOut = vDouble(chipsOut)
        // Gewinn, Verhätlnis und Geld
        oRES.chipsWin = oRES.chipsOut - oRES.chipsIn
        oRES.moneyIn = (oRES.chipsIn/100.00) * oRES.factor
        oRES.moneyOut = (oRES.chipsOut/100.00) * oRES.factor
        oRES.moneyWin = oRES.moneyOut - oRES.moneyIn
        
        oRES.ratio = (oRES.chipsIn > 0) ? (oRES.chipsOut / oRES.chipsIn) * 100 : 0

        self.changed = true
        
        for i in 0..<self.arrayResults.count {
            if self.arrayResults[i].id == oRES.id {
                 self.arrayResults[i] = oRES
            }
        }
        
        // THREAD!!!!
        if oRES.updateResultWS() {
            oRES.state = 1
        }
        
        groupBydate(TempDaten: self.arrayResults)
        calculateScore()
        calculateGroupedScores()
        self.saveDataToCoreData()
    }
    
    // Liste berechnen
    func calculateScore() {
        
        self.arrayScores.removeAll(keepCapacity: false)
        
        var lastDate: NSDate?
        
        self.arrayResults.sort( { $0.date.timeIntervalSinceNow < $1.date.timeIntervalSinceNow })
        
        if let lastResult: Results = self.arrayResults.last {
            lastDate = lastResult.date
        }
        
        for oRES in self.arrayResults {
            
            if !oRES.linkedPerson(self.arrayPersons)!.visible {
                continue
            }
            
            var oSCO: Scores? = self.arrayScores.filter( { $0.PER_ID == oRES.PER_ID} ).first
            if oSCO == nil {
                oSCO = Scores(PER_ID: oRES.PER_ID, chipsIn: oRES.chipsIn, chipsOut: oRES.chipsOut, moneyIn: oRES.moneyIn, moneyOut: oRES.moneyOut, position: 1)
                self.arrayScores.append(oSCO!)
            } else {
                oSCO!.games += 1
                oSCO!.chipsOut += oRES.chipsOut
                oSCO!.chipsIn += oRES.chipsIn
                oSCO!.moneyIn += oRES.moneyIn
                oSCO!.moneyOut += oRES.moneyOut
                oSCO!.maxWin = (oSCO!.maxWin < (oRES.moneyOut - oRES.moneyIn)) ? (oRES.moneyOut - oRES.moneyIn) : oSCO!.maxWin
                let ratio = oRES.chipsOut / vDouble((oRES.chipsIn != 0 ? oRES.chipsIn : 1)) * 100.00
                oSCO!.ratioMax = (oSCO!.ratioMax < ratio) ? ratio : oSCO!.ratioMax
   
            }
            
            if lastDate != nil && oRES.date == lastDate {
                for oSCO in self.arrayScores {
                    
                    let a = oSCO.ratio / vDouble((oSCO.games != 0 ? oSCO.games : 1))
                    oSCO.ratio = oSCO.chipsOut / vDouble((oSCO.chipsIn != 0 ? oSCO.chipsIn : 1)) * 100.00
                }
                var pos = 0
                self.arrayScores.sort( {$0.ratio > $1.ratio })
                for oSCO in self.arrayScores {
                    pos++
                    oSCO.lastPosition = pos
                }
                lastDate = nil
            }
        }
        
        for oSCO in self.arrayScores {

            let a = oSCO.ratio / vDouble((oSCO.games != 0 ? oSCO.games : 1))
            oSCO.ratio = oSCO.chipsOut / vDouble((oSCO.chipsIn != 0 ? oSCO.chipsIn : 1)) * 100.00
        }
        
        self.arrayScores.sort( {$0.ratio > $1.ratio })

        var pos = 0
        for oSCO in self.arrayScores {
            pos++
            oSCO.position = pos
        }
        
        sortArrayResults()
    }
    
    // Gruppierten Listen berechnen
    func calculateGroupedScores() {
        
        self.arrayGroupedScores.removeAll(keepCapacity: false)
        
        var group = [String:Int]()
        let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear
        
        for oRES in self.arrayResults {
            let components = NSCalendar.currentCalendar().components(flags, fromDate: oRES.date)

            var groupColumn = vString(components.year)
            
            if group[groupColumn] == nil {
                group[groupColumn] = group.count
            }
        }
        
        for year in group {
            
            var oGSCO: ScoreGroups? = self.arrayGroupedScores.filter( { $0.groupName == year.0} ).first
            
            if oGSCO == nil {
                oGSCO = ScoreGroups()
                oGSCO?.groupName = year.0
                oGSCO?.arrayScores = [Scores]()
            }
            
            var lastDate: NSDate?
            if let lastResult: Results = self.arrayResults.filter({ $0.year == year.0 }).reverse().last  {
                lastDate = lastResult.date
            }
            
            for oRES in self.arrayResults.filter({ $0.year == year.0 }).reverse() {
                
                if !oRES.linkedPerson(self.arrayPersons)!.visible {
                    continue
                }
                
                var oSCO: Scores? = oGSCO?.arrayScores.filter( { $0.PER_ID == oRES.PER_ID} ).first

                if oSCO == nil {
                    oSCO = Scores(PER_ID: oRES.PER_ID, chipsIn: oRES.chipsIn, chipsOut: oRES.chipsOut, moneyIn: oRES.moneyIn, moneyOut: oRES.moneyOut, position: 1)
                    oGSCO?.arrayScores.append(oSCO!)
                } else {
                    oSCO!.games += 1
                    oSCO!.chipsOut += oRES.chipsOut
                    oSCO!.chipsIn += oRES.chipsIn
                    oSCO!.moneyIn += oRES.moneyIn
                    oSCO!.moneyOut += oRES.moneyOut
                    oSCO!.maxWin = (oSCO!.maxWin < (oRES.moneyOut - oRES.moneyIn)) ? (oRES.moneyOut - oRES.moneyIn) : oSCO!.maxWin
                    let ratio = oRES.chipsOut / vDouble((oRES.chipsIn != 0 ? oRES.chipsIn : 1)) * 100.00
                    oSCO!.ratioMax = (oSCO!.ratioMax < ratio) ? ratio : oSCO!.ratioMax
                    
                }
                
                if lastDate != nil && oRES.date == lastDate {
                    for oSCO in oGSCO!.arrayScores {
                        
                        let a = oSCO.ratio / vDouble((oSCO.games != 0 ? oSCO.games : 1))
                        oSCO.ratio = oSCO.chipsOut / vDouble((oSCO.chipsIn != 0 ? oSCO.chipsIn : 1)) * 100.00
                    }
                    var pos = 0
                    oGSCO!.arrayScores.sort( {$0.ratio > $1.ratio })
                    for oSCO in oGSCO!.arrayScores {
                        pos++
                        oSCO.lastPosition = pos
                    }
                    lastDate = nil
                }

                
            }
            
            for oSCO in oGSCO!.arrayScores {
                
                let a = oSCO.ratio / vDouble((oSCO.games != 0 ? oSCO.games : 1))
                oSCO.ratio = oSCO.chipsOut / vDouble((oSCO.chipsIn != 0 ? oSCO.chipsIn : 1)) * 100.00
            }
            
            oGSCO!.arrayScores.sort( {$0.ratio > $1.ratio })
            
            var pos = 0
            for oSCO in oGSCO!.arrayScores {
                pos++
                oSCO.position = pos
            }
            
            self.arrayGroupedScores.append(oGSCO!)

        }
        
        self.arrayGroupedScores.sort( {$0.groupName > $1.groupName })


    }
    
    // Dictionary JSON
    func getDictionary(wsLink: String, PKL_ID: Int) -> [[String:NSObject]] {
        
        let tempPath = NSURL(string: link + wsLink + "?PKL_ID=\(PKL_ID)")
        
        if let path = tempPath {
            
            if let temp = NSData(contentsOfURL: path) {
                if let arayJSON = NSJSONSerialization.JSONObjectWithData(temp, options: .MutableContainers, error: nil) as? [[String:NSObject]] {
                    return arayJSON
                }
            }
            
        }
        
        return [[String:NSObject]]()
    }
    
    
    // Ergebnise nach Datum gruppieren
    func groupBydate(#TempDaten: [Results]) {
        
        var returnArray = [[Results]]()
        var group = [String:Int]()
        
        for oRES in TempDaten {
            
            var groupColumn = oRES.dateString
            
            if group[groupColumn] == nil {
                group[groupColumn] = group.count
            }
            
            if returnArray.count < group.count {
                
                returnArray.append([Results]())
                
            }
            
            returnArray[group[groupColumn]!].append(oRES)
            
        }
        
        self.arrayGroupedResults = returnArray
    }
    
}

