

import Foundation
import UIKit
import CoreLocation
import Alamofire

class NetworkWeatherManager {
    
    var boolComplition: ((Bool) -> Void)?
    func fetchCurrentWeather(forCity city: String, completionHandler: @escaping (CurrentWeather) -> Void) {
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric&lang=ru"
        if let url = URL(string: urlString) {
            AF.request(url).validate().responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(_) :
                    if let currentWeather = self.parceJSON(withData: dataResponse.data!) {
                        completionHandler(currentWeather)
                        self.boolComplition?(true)
                    }
                case .failure(let error) :
                    print(error.localizedDescription)
                    self.boolComplition?(false)
                }
            }
        }
    }
    
    func fetchCurrentWeatherForCoordinate(forLatitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (CurrentWeather) -> Void) {
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(forLatitude)&lon=\(longitude)&appid=\(apiKey)&units=metric&lang=ru"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let taskData = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    
                    if let currentWeather = self.parceJSON(withData: data) {
                        completionHandler(currentWeather)
                        self.boolComplition?(true)
                    } else {
                        self.boolComplition?(false)
                    }
                }
            }
            taskData.resume()
            
        } else
        { self.boolComplition?(false) }
    }
    
    func parceJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
