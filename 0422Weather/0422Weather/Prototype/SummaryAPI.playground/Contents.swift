import UIKit

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

//protoType  여기서 테스트 코딩을 하고 실제플젝에 옮기는 방식
let str = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=37.498206&lon=127.02761&appkey=l7xx1c33d545fe3849c5ad6cd2f72620e690"

let url = URL(string: str)!
let session = URLSession.shared
let task = session.dataTask(with: url) { (data, response, error) in
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
        let summary = try decoder.decode(WeatherSummary.self, from: data)
        summary.result.code
        summary.result.message
        // first last -> 0번쨰 마지막 접근하는데 업승면 nil 리턴해줌!!
        summary.weather.minutely.first?.sky.code


    }catch{
        print(error)
    }

}
task.resume()


// 통신시 err -> key 안맞는경우 , 오타날경우 , 구조안맞는경우

