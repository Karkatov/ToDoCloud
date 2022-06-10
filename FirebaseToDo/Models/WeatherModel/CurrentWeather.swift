//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Duxxless on 26.01.2022.
//

import Foundation

struct CurrentWeather {
    
    let detailWeather = [String]()
    let cityName: String
    let temperature: Double
    var descriptionTemperature: String {
        return "Температура: \(temperatureString) C°"
    }
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    var descriptionFeelsLike: String {
        return "Ощущается как: \(feelsLikeTemperatureString) C°"
    }
    
    let conditionCode: Int //image weather
    var systemIconWheatherString: String {
        switch conditionCode {
        case 200...232 : return "cloud.bolt.rain.fill"
        case 300...321 : return "cloud.drizzle.fill"
        case 500...531 : return "cloud.rain.fill"
        case 600...622 : return "cloud.snow.fill"
        case 701...781 : return "smoke.fill"
        case 800 : return "sun.min.fill"
        case 801...804 : return "cloud.fill"
            
        default : return "nosign"
        }
    }
    
    let description: String?
    var descriptionString: String {
        return  "На улице: \((description ?? "-").lowercased())"
    }
    
    let clouds: Int?
    var cloudsString: String {
        return "Облачность: \(clouds ?? 0)%"
    }
    
    let humidity: Int?
    var humidityString: String {
        return "Влажность: \(humidity ?? 0)%"
    }
    
    let maxTemp: Double?
    var maxTempString: String {
        return "Макс. температура: \(maxTemp)"
    }
    
    let minTemp: Double?
    var minTempString: String {
        return "Мин. температура: \(minTemp)"
    }
    let speed: Double
    var speedString: String {
        return "Cкорость ветра: \(String(format: "%.0f", speed)) м/с"
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
        description = currentWeatherData.weather.first!.weatherDescription
        clouds = currentWeatherData.clouds.all
        humidity = currentWeatherData.main.humidity
        maxTemp = currentWeatherData.main.tempMax
        minTemp = currentWeatherData.main.tempMin
        speed = currentWeatherData.wind.speed
    }
    
    func weatherDetail() -> [String] {
        let detail = [cityName, descriptionTemperature,  descriptionFeelsLike, speedString, cloudsString, humidityString, descriptionString]
        return detail
    }
}

