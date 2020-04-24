//
//  ViewController.swift
//  0422Weather
//
//  Created by 이성근 on 22/04/2020.
//  Copyright © 2020 Draw_corp. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    lazy var locatoinManager : CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!

    let tempFormatter : NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 1
        return f
    }()

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()

    var topInset : CGFloat = 0.0

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if topInset == 0.0 {
            let firstIndexPath = IndexPath(row:0, section: 0)

            if let cell = listTableView.cellForRow(at: firstIndexPath) {
                topInset = listTableView.frame.height - cell.frame.height

                var inset = listTableView.contentInset
                inset.top = topInset
                listTableView.contentInset = inset
                //contentINst -> 여백
            }
        }

        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.backgroundColor = UIColor.clear

//        WeatherDataSource.shared.fetchSummary(lat: 37.498206, lon: 127.02761) {
//            self.listTableView.reloadData()
//        }
//        WeatherDataSource.shared.fetchForecast(lat: 37.498206, lon: 127.02761) {
//            self.listTableView.reloadData()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locatoinManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse , .authorizedAlways :
                updateLocation()
            case.denied ,.restricted:
                break
            default:
                return
            }
        }else {
            // error
        }

    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return WeatherDataSource.shared.forecastList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell

            if let target = WeatherDataSource.shared.summary?.weather.minutely.first {
                cell.weatherImageView.image = UIImage(named: target.sky.code)
                cell.statusLabel.text = target.sky.name

                cell.minMaxLabel.text = "최소 \(target.temperature.tmin.toTempertureString(using: tempFormatter))º 최대 \(target.temperature.tmax.toTempertureString(using: tempFormatter))º"
                cell.currentTemperatuerLable.text = "\(target.temperature.tc.toTempertureString(using: tempFormatter))º"
            }
            return cell

        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
            let target = WeatherDataSource.shared.forecastList[indexPath.row]

            cell.statusLabel.text = target.skyName
            cell.weatherImageView.image = UIImage(named:target.skyCode)
            cell.temptuerLabel.text = "\(target.temperature.toTemperatureString(using: tempFormatter))º"

            dateFormatter.dateFormat = "M.d (E)"
            cell.dateLabel.text = dateFormatter.string(from: target.date)

            dateFormatter.dateFormat = "HH:00"
            cell.timeLabel.text = dateFormatter.string(from: target.date)

            return cell
        }
    }
}

extension ViewController : UITableViewDelegate {

}

// 셀안의 객체들을 VC 에 연결하면 안되는 이유
//


extension ViewController : CLLocationManagerDelegate {
    func updateLocation()  {
        locatoinManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(location)
            WeatherDataSource.shared.fetch(location: location) {
                self.listTableView.reloadData()
            }
            // 리버스 지오코딩
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placeMark, error) in
                if let place = placeMark?.first {
                    if let gu = place.locality, let dong = place.subLocality {
                        self.locationLabel.text = "\(gu) \(dong)"
                    }else {
                        self.locationLabel.text = place.name
                    }
                }
            }
        }

        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locatoinManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse , .authorizedAlways :
            updateLocation()
        case.denied ,.restricted:
            break
        default:
            return
        }
    }
}
