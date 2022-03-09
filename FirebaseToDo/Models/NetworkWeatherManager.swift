//
//  NetworkWeatherManager.swift
//  Weather App
//
//  Created by Duxxless on 24.01.2022.
//

import Foundation
import UIKit

class NetworkWeatherManager {
    
    var boolComplition: ((Bool) -> Void)?
    
    func fetchCurrentWeather(forCity city: String, completionHandler: @escaping (CurrentWeather) -> Void) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric&lang=ru"
        print(urlString)
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
