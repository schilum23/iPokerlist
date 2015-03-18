//
//  Data.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

let link = "http://217.160.178.136/Service.asmx/"
let wsLinkPersons = "getPersons"
let wsLinkResults = "pokerlisteResults"
let wsLists = ""

class Data: NSObject {
    
    var arrayResults = [Results]()
    var arrayGroupedResults = [[Results]]()
    var arrayPersons = [Persons]()
    var arrayScores = [Scores]()
    var arrayGroupedScores = [ScoreGroups]()
    var changed = false
    var PKL_ID = 1//NSUserDefaults.standardUserDefaults().integerForKey("PKL_ID")
    
    
    var lists = [[String:NSObject]]()
    var error = [String:NSObject]()
    
    override init() {
        super.init()
        getAllData()
    }
    
    func getAllData() {
        
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "PKL_ID")
        let PKL_ID = NSUserDefaults.standardUserDefaults().integerForKey("PKL_ID")
        
        // Resultate
        let wsResults = getDictionary(wsLinkResults, PKL_ID: PKL_ID)
        
        for dic in wsResults {
            var newResult: Results = Results(wsData: dic)
            arrayResults.append(newResult)
        }
        
        // Nach Datum gruppieren
        groupBydate(TempDaten: arrayResults)
        
        // Personen
        let wsPersons = getDictionary(wsLinkPersons, PKL_ID: PKL_ID)
        
        for dic in wsPersons {
            var newPerson: Persons = Persons(wsData: dic)
            arrayPersons.append(newPerson)
        }
        
        calculateScore()
        calculateGroupedScores()
    }
    
    func sortArrayPersons() {
        self.arrayPersons.sort( {$0.name.lowercaseString < $1.name.lowercaseString})
    }
    
    func sortArrayResults() {
        self.arrayResults.sort( { $0.date == $1.date ? $0.name < $1.name : $0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow })
    }
    
    func calculateScore() {
        
        self.arrayScores.removeAll(keepCapacity: false)
        
        for oRES in self.arrayResults {
            
            var oSCO: Scores? = self.arrayScores.filter( { $0.PER_ID == oRES.PER_ID} ).first?
            if oSCO == nil {
                oSCO = Scores(PER_ID: oRES.PER_ID, name: oRES.name, chipsIn: oRES.chipsIn, chipsOut: oRES.chipsOut, position: 1)
                self.arrayScores.append(oSCO!)
            } else {
                oSCO!.games += 1
                oSCO!.chipsOut += oRES.chipsOut
                oSCO!.chipsIn += oRES.chipsIn

            }
        }
        
        for oSCO in self.arrayScores {

            let a = oSCO.ratio / vDouble((oSCO.games != 0 ? oSCO.games : 1))
            oSCO.ratio = oSCO.chipsOut / vDouble((oSCO.chipsIn != 0 ? oSCO.chipsIn : 1)) * 100.00
        }
        
        self.arrayScores.sort( {$0.ratio > $1.ratio })

    }
    
    
    func calculateGroupedScores() {
        
        self.arrayGroupedScores.removeAll(keepCapacity: false)
        
        var group = [String:Int]()
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        
        for oRES in self.arrayResults {
            let components = NSCalendar.currentCalendar().components(flags, fromDate: oRES.date)

            var groupColumn = vString(components.year)
            
            if group[groupColumn] == nil {
                group[groupColumn] = group.count
            }
        }
        
        for year in group {
            
            var oGSCO: ScoreGroups? = self.arrayGroupedScores.filter( { $0.groupName == year.0} ).first?
            
            if oGSCO == nil {
                oGSCO = ScoreGroups()
                oGSCO?.groupName = year.0
                oGSCO?.arrayScores = [Scores]()
            }
            
            for oRES in self.arrayResults.filter({ $0.year == year.0 }) {
                
                var oSCO: Scores? = oGSCO?.arrayScores.filter( { $0.PER_ID == oRES.PER_ID} ).first?

                if oSCO == nil {
                    oSCO = Scores(PER_ID: oRES.PER_ID, name: oRES.name, chipsIn: oRES.chipsIn, chipsOut: oRES.chipsOut, position: 1)
                    oGSCO?.arrayScores.append(oSCO!)
                } else {
                    oSCO!.games += 1
                    oSCO!.chipsOut += oRES.chipsOut
                    oSCO!.chipsIn += oRES.chipsIn
                    
                }
                
            }
            
            for oSCO in oGSCO!.arrayScores {
                
                let a = oSCO.ratio / vDouble((oSCO.games != 0 ? oSCO.games : 1))
                oSCO.ratio = oSCO.chipsOut / vDouble((oSCO.chipsIn != 0 ? oSCO.chipsIn : 1)) * 100.00
            }
            
            oGSCO!.arrayScores.sort( {$0.ratio > $1.ratio })
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
    
    
    // Daten gruppieren
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
    
    // Daten gruppieren
    func score(#TempDaten: [[String:NSObject]], column: String) -> [[String:NSObject]] {
        
        var result = [[String:NSObject]]()
        var group = [String:Int]()
        var scoreRow = [String:[String:NSObject]]()
        var sumIN: Double = 0
        var sumOUT: Double = 0
        
        for dic in TempDaten {
            
            var groupColumn = dic["Name"] as String!
            var row = [String:NSObject]()
            
            let INNew: Double = dic["Eingezahlt"] as Double
            let OUTNew: Double = dic["Ausgezahlt"] as Double
            var IN: Double = 0
            var OUT: Double = 0
            
            if scoreRow[groupColumn] != nil {
                row = scoreRow[groupColumn]!
                IN = row["Eingezahlt"] as Double
                OUT = row["Ausgezahlt"] as Double
            }
            
            row["Name"] = groupColumn
            row["Eingezahlt"] = INNew + IN
            row["Ausgezahlt"] = OUTNew + OUT
            
            
            scoreRow[groupColumn] = row
            
        }
        
        for dic in scoreRow {
            
            result.append(dic.1)
        }
        
        return result
    }
    
    
}

