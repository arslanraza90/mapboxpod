//
//  APIService.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 5/29/23.
//

import Foundation
import GooglePlaces

struct Weather: Codable {
    let temp: Int
    let iconURL: URL
}

final class APIService {
    
    let apiKey = "92baa5b07d9b0604b34d250d24ccbe07"
    static let shared = APIService()
    
    private init() {}
    
    func getWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<Weather, Error>) -> Void) {
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)"
        guard let url =  URL(string: weatherURL) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    guard let main = json["main"] as? [String: AnyObject] else { return }
                    guard let temp = main["temp"] as? Double  else { return }
                    let temperature = Int(temp)
                    
                    guard let weatherList = json["weather"] as? [[String: AnyObject]], let weather = weatherList.first else { return }
                    guard let icon = weather["icon"] as? String else { return }
                    let iconUrl = "https://openweathermap.org/img/wn/\(icon).png"
                    guard let url = URL(string: iconUrl) else { return }
                    
                    completion(.success(Weather(temp: temperature, iconURL: url)))
                    
                } catch (let err) {
                    completion(.failure(err))
                }
            } else {
                completion(.failure(error!))
            }
        }
        task.resume()
    }
}
