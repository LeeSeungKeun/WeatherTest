//
//  SummaryTableViewCell.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var currentTemperatuerLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
        statusLabel.textColor = UIColor.white
        minMaxLabel.textColor = statusLabel.textColor
        currentTemperatuerLable.textColor = statusLabel.textColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
