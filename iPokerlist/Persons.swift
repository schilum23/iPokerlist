//
//  Persons.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Persons: NSObject {
    
    var id: Int = 0
    var created: NSDate = NSDate()
    var changed: NSDate = NSDate()
    var deleted: NSDate?
    var state: Int = 1
    var PKL_ID: Int = 1
    var name: String = ""
    var defaultVisible: Bool = true
    var visible: Bool = true
    var me: Bool = false
    var error: NSError?
    
    override init() {
        super.init()
    }
    
    init(wsData: [String:NSObject]) {
        super.init()
        
        self.id = vInt(wsData["id"])
        self.created = vDate(wsData["created"])
        self.changed = vDate(wsData["changed"])
        self.deleted = vDate(wsData["Deleted"])
        self.PKL_ID = vInt(wsData["PKL_ID"])
        self.name = vString(wsData["name"])
        self.defaultVisible = vBool(wsData["defaultVisible"])
        
        // Status 0 = von Webservice
        self.state = 0
        
    }
    
    init(name: String) {
        self.name = name
    }
    
    func addPersonWS() {
        
        let link = "http://217.160.178.136/Service.asmx/addPerson?PER_Name=\(self.name)&PER_PKL=\(self.PKL_ID)"
        
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
    
    func updatePersonWS() {
        
        let dateFormat = "yyyyMMdd HH:mm:ss"
        let link = "http://217.160.178.136/Service.asmx/updatePerson?PER_ID=\(self.id)&PER_Name=\(self.name)&PER_Changed=\(vString(self.changed, dateFormat: dateFormat))"
        
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
