//
//  Forecast.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import Foundation

struct ForecastData {
    let date : Date
    let skyCode : String
    let skyName : String
    let temperature : Double
}


struct Forecast: Codable{
    struct Weather : Codable{
        struct Forecast3Days : Codable {
            struct Fcst3Hour : Codable {
               @objcMembers class Sky : NSObject, Codable {
                    let code4hour: String
                    let name4hour: String
                    let code7hour: String
                    let name7hour: String
                    let code10hour: String
                    let name10hour: String
                    let code13hour: String
                    let name13hour: String
                    let code16hour: String
                    let name16hour: String
                    let code19hour: String
                    let name19hour: String
                    let code22hour: String
                    let name22hour: String
                    let code25hour: String
                    let name25hour: String
                    let code28hour: String
                    let name28hour: String
                    let code31hour: String
                    let name31hour: String
                    let code34hour: String
                    let name34hour: String
                    let code37hour: String
                    let name37hour: String
                    let code40hour: String
                    let name40hour: String
                    let code43hour: String
                    let name43hour: String
                    let code46hour: String
                    let name46hour: String
                    let code49hour: String
                    let name49hour: String
                    let code52hour: String
                    let name52hour: String
                    let code55hour: String
                    let name55hour: String
                    let code58hour: String
                    let name58hour: String
                    let code61hour: String
                    let name61hour: String
                    let code64hour: String
                    let name64hour: String
                    let code67hour: String
                    let name67hour: String
                }
                 @objcMembers class Temperature : NSObject, Codable {
                    let temp4hour: String
                    let temp7hour: String
                    let temp10hour: String
                    let temp13hour: String
                    let temp16hour: String
                    let temp19hour: String
                    let temp22hour: String
                    let temp25hour: String
                    let temp28hour: String
                    let temp31hour: String
                    let temp34hour: String
                    let temp37hour: String
                    let temp40hour: String
                    let temp43hour: String
                    let temp46hour: String
                    let temp49hour: String
                    let temp52hour: String
                    let temp55hour: String
                    let temp58hour: String
                    let temp61hour: String
                    let temp64hour: String
                    let temp67hour: String
                    }
                    let sky: Sky
                    let temperature : Temperature
                }

            let fcst3hour : Fcst3Hour
            let timeRelease : String
        }
        let forecast3days : [Forecast3Days]

        func arrayRepersentation() -> [ForecastData] {
            guard let target = forecast3days.first?.fcst3hour else {
                return []
            }

            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let str = forecast3days.first?.timeRelease , let baseDate = f.date(from: str) else {
                return []
            }

            var data = [ForecastData]()

            for hour in stride(from: 4, to: 67, by: 3) {
                var key = "code\(hour)hour"

                guard let skyCode = target.sky.value(forKey: key) as? String else {
                    continue
                }

                key = "name\(hour)hour"
                guard let skyName = target.sky.value(forKey: key) as? String else {
                    continue
                }

                key = "temp\(hour)hour"
                guard let tempStr = target.temperature.value(forKey: key) as? String else {
                    continue
                }
                guard let temp = Double(tempStr) else {continue}


                let date = baseDate.addingTimeInterval(TimeInterval(hour)*3600)

                let forecast = ForecastData(date: date, skyCode: skyCode, skyName: skyName, temperature: temp)

                data.append(forecast)

            }

            return data

        }
    }

    struct Result : Codable{
        let code : Int
        let message : String
    }

    let weather : Weather
    let result : Result
}
