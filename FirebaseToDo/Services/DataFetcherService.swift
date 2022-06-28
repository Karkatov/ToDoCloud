

import Foundation
import CoreLocation

class DataFetcherService {
    
    let networkRateManager = NetworkRateManager()
    
    func fetchExchangeRate(complition: @escaping (CurrencyRateData?) -> Void) {
        let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
        networkRateManager.fetchGenericJSONData(urlString: urlString, response: complition)
    }
    
    func fetchWeather(forCity city: String, completionHandler: @escaping (CurrentWeatherData?) -> Void) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric&lang=ru"
        networkRateManager.fetchGenericJSONData(urlString: urlString, response: completionHandler)
    }
    
    func fetchCurrentWeatherForCoordinate(forLatitude: CLLocationDegrees, longitude: CLLocationDegrees, complitionHandler: @escaping (CurrentWeatherData?) -> Void) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(forLatitude)&lon=\(longitude)&appid=\(apiKey)&units=metric&lang=ru"
        networkRateManager.fetchGenericJSONData(urlString: urlString, response: complitionHandler)
    }
}
