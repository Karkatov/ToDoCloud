

import Foundation

class DataFetcherService {
    
    let networkRateManager = NetworkRateManager()
    
    func fetchExchangeRate(complition: @escaping (CurrencyRateData?) -> Void) {
        networkRateManager.fetchGenericJSONData(response: complition)
    }
    
    func fetchWeather(forCity city: String, completionHandler: @escaping (CurrentWeatherData?) -> Void) {
        networkRateManager.fetchGenericJSONData(response: completionHandler)
    }
}
