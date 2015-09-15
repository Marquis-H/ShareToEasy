//
//  HistoryTableViewCell.swift
//  ShareToEasy
//
//  Created by Marquis on 15/9/11.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var HSharePlatform: UILabel!
    @IBOutlet weak var HShareTime: UILabel!
    @IBOutlet weak var HIsSuccess: UIImageView!
    @IBOutlet weak var HShareText: UILabel!
}
