//
//  HistoryShareData.swift
//  ShareToEasy
//
//  Created by Marquis on 15/9/15.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import Foundation
import CoreData

@objc(HistoryShareData)

class HistoryShareData: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var status: String
    @NSManaged var platform: String
    @NSManaged var text: String
    @NSManaged var createdAt: NSDate

}
