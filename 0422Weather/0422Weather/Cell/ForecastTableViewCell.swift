//
//  ForecastTableViewCell.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var temptuerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.white
        timeLabel.textColor = dateLabel.textColor
        statusLabel.textColor = dateLabel.textColor
        temptuerLabel.textColor = dateLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
