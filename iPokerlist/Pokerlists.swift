//
//   MARK: - Help Functions Pokerlists.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.04.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class Pokerlists: NSObject {
    
    // MARK: - Variablen
    var id: Int = 0
    var created: NSDate = NSDate()
    var changed: NSDate = NSDate()
    var deleted: NSDate?
    var state: Int = 1
    var name: String = ""
    var admin: Bool = false
    var active: Bool = false
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
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.admin = aDecoder.decodeObjectForKey("admin") as! Bool
        self.active = aDecoder.decodeObjectForKey("active") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(created, forKey: "created")
        aCoder.encodeObject(changed, forKey: "changed")
        aCoder.encodeObject(deleted, forKey: "deleted")
        aCoder.encodeObject(state, forKey: "state")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(admin, forKey: "admin")
        aCoder.encodeObject(active, forKey: "active")
    }
    
}
