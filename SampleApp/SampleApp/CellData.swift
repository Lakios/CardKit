//
//  File.swift
//  SampleApp
//
//  Created by Alex Korotkov on 9/18/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

import UIKit

class CellData: UITableViewCell {

    @IBOutlet var lblName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
