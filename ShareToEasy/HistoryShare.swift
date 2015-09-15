//
//  HistoryShare.swift
//  ShareToEasy
//
//  Created by Marquis on 15/9/11.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import UIKit

class HistoryShare {
    // MARK: Properties
    
    var hSharePlatformName: String?
    var photo: UIImage?
    var hShareTime: String?
    var hShareText: String?
    
    // Initialization
    
    init?(hSharePlatformName: String, photo: UIImage, hShareTime: String, hShareText: String){
        self.hSharePlatformName = hSharePlatformName
        self.photo = photo
        self.hShareTime = hShareTime
        self.hShareText = hShareText
        if hSharePlatformName.isEmpty || hShareText.isEmpty{
            return nil
        }
    }
}

