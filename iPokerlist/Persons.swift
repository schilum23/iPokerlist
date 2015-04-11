//
//  Persons.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Persons: NSObject {
    
    // MARK: - Variablen
    var id: Int = 0
    var created: NSDate = NSDate()
    var changed: NSDate = NSDate()
    var deleted: NSDate?
    var state: Int = 0
    var PKL_ID: Int = 1
    var name: String = ""
    var defaultVisible: Bool = true
    var visible: Bool = true
    var me: Bool = false
    var countGames: Int = 0
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
        self.state = aDecoder.decodeObjectForKey("state") as! Int
        self.PKL_ID = aDecoder.decodeObjectForKey("PKL_ID") as! Int
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.defaultVisible = aDecoder.decodeObjectForKey("defaultVisible") as! Bool
        self.visible = aDecoder.decodeObjectForKey("visible") as! Bool
        self.me = aDecoder.decodeObjectForKey("me") as! Bool
        self.countGames = aDecoder.decodeObjectForKey("countGames") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(created, forKey: "created")
        aCoder.encodeObject(changed, forKey: "changed")
        aCoder.encodeObject(deleted, forKey: "deleted")
        aCoder.encodeObject(state, forKey: "state")
        aCoder.encodeObject(PKL_ID, forKey: "PKL_ID")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(defaultVisible, forKey: "defaultVisible")
        aCoder.encodeObject(visible, forKey: "visible")
        aCoder.encodeObject(me, forKey: "me")
        aCoder.encodeObject(countGames, forKey: "countGames")
    }
    
    // Init mit JSON
    init(wsData: [String:NSObject]) {
        super.init()
        
        self.id = vInt(wsData["id"])
        self.created = vDate(wsData["created"])
        self.changed = vDate(wsData["changed"])
        self.deleted = vDate(wsData["Deleted"])
        self.PKL_ID = vInt(wsData["PKL_ID"])
        self.name = vString(wsData["name"])
        self.defaultVisible = vBool(wsData["defaultVisible"])
        self.me = (self.id == NSUserDefaults.standardUserDefaults().integerForKey("PER_ID"))
        
        // Status 1 = von Webservice
        self.state = 1
    }
    
    // Init mit Name
    init(name: String) {
        self.name = name
    }
    
    // MARK: - Funktionen
    // Spieler als "Ich" markieren
    func setToMe(me: Bool) {
        self.me = me
        NSUserDefaults.standardUserDefaults().setInteger(!me ? 0 : self.id, forKey: "PER_ID")
    }

    // Spieler hinzufügen
    func addPersonWS() -> Bool {
        
        let link = "http://217.160.178.136/Service.asmx/addPerson?PER_Name=\(self.name)&PER_PKL=\(self.PKL_ID)"
        
        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as! [[String:NSObject]]
            
            if error != nil {
                println("ERROR: Fehler beim hinzufügen einer Person. \(error!.description)")
            }
            return (self.error == nil)
        }
        return false
    }
    
    // Spieler löschen
    func deletePersonWS() -> Bool {
        
        let dateFormat = "yyyyMMdd HH:mm:ss"
        let link = "http://217.160.178.136/Service.asmx/updatePerson?PER_ID=\(self.id)&PER_Name=\(self.name)&PER_Changed=\(vString(self.changed, dateFormat: dateFormat))&PER_Deleted=\(vString(self.deleted, dateFormat: dateFormat))"
        
        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as! [[String:NSObject]]
            
            if error != nil {
                println("ERROR: Fehler beim hinzufügen einer Person. \(error!.description)")
            }
            return (self.error == nil)
        }
        return false
    }

    
    // Spieler updaten
    func updatePersonWS() -> Bool {
        
        let dateFormat = "yyyyMMdd HH:mm:ss"
        let link = "http://217.160.178.136/Service.asmx/updatePerson?PER_ID=\(self.id)&PER_Name=\(self.name)&PER_Changed=\(vString(self.changed, dateFormat: dateFormat))&PER_Deleted="
        
        if let json = getJSONData(link) {
            var tempError = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: &error) as! [[String:NSObject]]
            
            if error != nil {
                println("ERROR: Fehler beim hinzufügen einer Person. \(error!.description)")
            }
            return (self.error == nil)
        }
        return false
    }
    
}
