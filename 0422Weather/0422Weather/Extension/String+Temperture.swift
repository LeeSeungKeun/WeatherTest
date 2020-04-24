//
//  String+Temperture.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import Foundation

extension String {
    func toTempertureString(using formatter : NumberFormatter) -> String {
        guard let tempValue = Double(self) else{ return self }

        return formatter.string(for: tempValue) ?? self
    }
}
