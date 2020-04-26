//
//  WeatherDataSource.swift
//  0422Weather
//
//  Created by 이성근 on 23/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherDataSource {
    //Singleton
    static let shared = WeatherDataSource()
    private init(){}

    var summary : WeatherSummary?
    var forecastList = [ForecastData]()

    let group = DispatchGroup() // 디스패치그룹
    let workQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent) // 새로운큐 생성

    // 그룹/큐 패치 메서드
    func fetch(location : CLLocation, completion: @escaping ()->() )  {
        group.enter()
        workQueue.async {
            self.fetchSummary(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                self.group.leave()
            }
        }

        group.enter()

        workQueue.async {
            self.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                self.group.leave()
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }

    private func fetchSummary(lat: Double , lon : Double , completion: @escaping ()->() ) {
        let str = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=\(lat)&lon=\(lon)&appkey=\(appKey)"

        guard let url = URL(string: str) else{
            fatalError()
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            // defer문 쓰면 클로저가 끝날시 무조건 호출이된다(실패/성공 둘다)
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            // #1
            if let error = error {
                fatalError(error.localizedDescription)
            }
            // #2
            guard let httpRespose = response as? HTTPURLResponse else {
                fatalError()
            }

            guard (200..<400).contains(httpRespose.statusCode) else {
                fatalError()
            }
            // #3
            guard let data = data else {
                fatalError()
            }

            do {
                let decoder = JSONDecoder()
                self.summary = try decoder.decode(WeatherSummary.self, from: data)
            }catch{
                print(error)
            }
        }
        task.resume()
    }

    private func fetchForecast(lat: Double , lon : Double , completion: @escaping ()->() ) {
        let str = "https://apis.openapi.sk.com/weather/forecast/3days?version=2&lat=\(lat)&lon=\(lon)&appkey=\(appKey)"

        guard let url = URL(string: str) else {fatalError()}

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            // #1
            if let error = error {
                fatalError(error.localizedDescription)
            }
            // #2
            guard let httpRespose = response as? HTTPURLResponse else {
                fatalError()
            }

            guard (200..<400).contains(httpRespose.statusCode) else {
                print(httpRespose.statusCode)
                fatalError()
            }
            // #3
            guard let data = data else {
                fatalError()
            }

            do {
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(Forecast.self, from: data)
                dump(forecast)
                self.forecastList = forecast.weather.arrayRepersentation()
            }catch{
                print(error)
            }

        }
        task.resume()
    }
}
