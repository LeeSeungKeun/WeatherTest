//
//  Double+Temperture.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import Foundation

extension Double {
    func toTemperatureString(using formatter : NumberFormatter) -> String {
        return formatter.string(for: self) ?? "\(self)"
    }
}
