//
//  CDData.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.04.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import Foundation
import CoreData

class CDData: NSManagedObject {

    @NSManaged var cdData: NSData
    @NSManaged var pkl_ID: NSNumber

}
