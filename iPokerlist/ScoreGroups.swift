//
//  ScoreGroup.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 11.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class ScoreGroups: NSObject {
    
    // MARK: - Variablen
    var groupName: String = ""
    var arrayScores: [Scores]!
    
    // MARK: - Init / Coder
    override init() {
        super.init()
    }
    
    init(coder aDecoder: NSCoder!) {
        self.groupName = aDecoder.decodeObjectForKey("groupName") as! String
        self.arrayScores = aDecoder.decodeObjectForKey("arrayScores") as! [Scores]
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(groupName, forKey: "groupName")
        aCoder.encodeObject(arrayScores, forKey: "arrayScores")
    }
   
}
