//
//  WeatherSummary.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import Foundation

struct WeatherSummary : Codable {
    struct Weather : Codable {
        struct Minutely : Codable {
            // sky strut
            struct Sky : Codable {
                let code : String
                let name : String
            }
            // temperature struct
            struct Temperature : Codable {
                let tc:String
                let tmin : String
                let tmax : String
            }
            // 선언부
            let sky : Sky
            let temperature : Temperature
        }

        let minutely : [Minutely]
    }

    struct Reseult : Codable {
        let code : Int
        let message : String
    }

    let weather : Weather
    let result : Reseult
}
