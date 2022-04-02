
//  ViewController.swift
//  Weather App
//
//  Created by Duxxless on 21.01.2022.
//

import UIKit

class WeatherVC: UIViewController {
    
    var array = [String]()
    let defaultColor = UIColor(named: "DarkWhite")
    let backgroundImageView = UIImageView()
    let wheatherIconImageView = UIImageView()
    let temperatureLabel = UILabel()
    let feelsLikeTemperatureLabel = UILabel()
    let cityLabel = UILabel()
    let searchCityButton = UIButton()
    let weatherWeek = UIButton()
    let locationButton = UIButton()
    let spiner = UIActivityIndicatorView()
    let networkWeatherManager = NetworkWeatherManager()
    let networkTranslate = NetworkTranslate()
    let userDefaults = UserDefaults()
    let queue = DispatchQueue(label: "serial", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.startAnimating()
        setStyle()
        setLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fistUpdateUI()
    }
}

// MARK: - Methods
extension WeatherVC {
    
    func setStyle() {
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "blur")
        backgroundImageView.contentMode = .scaleAspectFill
        
        wheatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        wheatherIconImageView.image = UIImage(systemName: "nil")
        wheatherIconImageView.tintColor = defaultColor
        wheatherIconImageView.contentMode = .scaleAspectFill
        
        temperatureLabel.alpha = 0
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        feelsLikeTemperatureLabel.alpha = 0
        feelsLikeTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTemperatureLabel.font = UIFont.systemFont(ofSize: 22)
        feelsLikeTemperatureLabel.text = ""
        feelsLikeTemperatureLabel.textAlignment = .center
        feelsLikeTemperatureLabel.textColor = defaultColor
        
        searchCityButton.pulsate()
        searchCityButton.translatesAutoresizingMaskIntoConstraints = false
        let searchImage = UIImage(systemName: "magnifyingglass.circle.fill")
        searchCityButton.setBackgroundImage(searchImage, for: .normal)
        searchCityButton.tintColor = defaultColor
        searchCityButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        
        weatherWeek.isHidden = true
        weatherWeek.translatesAutoresizingMaskIntoConstraints = false
        let weatherWeekImage = UIImage(systemName: "line.3.horizontal.circle.fill")
        weatherWeek.setBackgroundImage(weatherWeekImage, for: .normal)
        weatherWeek.tintColor = defaultColor
        weatherWeek.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .right
        cityLabel.text = ""
        if let cityCapitalized = cityLabel.text?.capitalized {
            cityLabel.text = cityCapitalized
        } else { return }
        cityLabel.font = UIFont.systemFont(ofSize: 34)
        cityLabel.textColor = defaultColor
        
        locationButton.pulsate()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        let locationImage = UIImage(systemName: "location.circle.fill")
        locationButton.setBackgroundImage(locationImage, for: .normal)
        locationButton.tintColor = defaultColor
        locationButton.addTarget(self, action: #selector(findPosition), for: .touchUpInside)
        
        spiner.translatesAutoresizingMaskIntoConstraints = false
        spiner.style = .large
        spiner.color = defaultColor
        spiner.hidesWhenStopped = true
        spiner.startAnimating()
    }
    
    func makeTemperatureText(temperature: String) -> NSAttributedString {
        let boldAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor: defaultColor,
            .foregroundColor : defaultColor,
            .font : UIFont.boldSystemFont(ofSize: 80)
        ]
        
        let celciusAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 60),
            .foregroundColor : defaultColor
        ]
        
        let attributedString = NSMutableAttributedString(string: temperature, attributes: boldAttributes)
        attributedString.append(NSAttributedString(string: "℃", attributes: celciusAttributes))
        return attributedString
    }
    
    // MARK: - Methods
    @objc func presentAlert() {
        
        searchCityButton.pulsate()
        presentSearchAlertController(tittle: "Введите название города", message: nil, style: .alert) { city in
            DispatchQueue.main.async {
                self.spiner.startAnimating()
            }
            //UserDefaults
            self.userDefaults.set(city, forKey: "city")
            self.networkWeatherManager.fetchCurrentWeather(forCity: city) { [weak self] currentWeather in
                self?.updateInterfaceWith(weather: currentWeather)
                self?.array = currentWeather.weatherDetail()
            }
            self.networkWeatherManager.boolComplition = { [weak self] error in
                if error == false {
                    self?.errorAlertController()
                    DispatchQueue.main.async {
                        self?.spiner.stopAnimating()
                    }
                }
            }
        }
    }
    
    @objc func showDetail() {
        
        let secondVC = DetailWeatherVC()
        secondVC.detail = array
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @objc func findPosition() {
        locationButton.pulsate()
        locationButton.opacityAnimation()
        //locationButton.shake()
    }
    
    func showAnimation() {
        self.wheatherIconImageView.pulsateImage()
        dispatch(object: temperatureLabel, duration: 0.3)
        dispatch(object: feelsLikeTemperatureLabel, duration: 0.5)
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        
        self.temperatureLabel.alpha = 0
        self.wheatherIconImageView.alpha = 0
        self.feelsLikeTemperatureLabel.alpha = 0
        
        DispatchQueue.main.async {
            self.weatherWeek.isHidden = false
            self.weatherWeek.pulsate()
            self.wheatherIconImageView.pulsateImage()
            self.wheatherIconImageView.image = UIImage(systemName: weather.systemIconWheatherString)
            self.spiner.stopAnimating()
            
            self.temperatureLabel.attributedText = self.makeTemperatureText(temperature: weather.temperatureString)
            
            self.cityLabel.text = weather.cityName
            
            self.feelsLikeTemperatureLabel.text = "Ощущается как \(weather.feelsLikeTemperatureString)º"
        }
        dispatch(object: self.temperatureLabel, duration: 1)
        dispatch(object: self.feelsLikeTemperatureLabel, duration: 1)
    }
    
    
    private func dispatch(object: UILabel, duration: Double) {
        
        DispatchQueue.main.sync {
            object.opacityAnimation(myDuration: duration)
        }
    }
    
    
    func fistUpdateUI() {
        
        queue.async {
            if let city = self.userDefaults.object(forKey: "city") as? String {
                self.networkWeatherManager.fetchCurrentWeather(forCity: city) { [weak self]  currentWeather in
                    self?.updateInterfaceWith(weather: currentWeather)
                    self?.array = currentWeather.weatherDetail()
                    return
                }
            } else {
                self.networkWeatherManager.fetchCurrentWeather(forCity: "Moscow") { [weak self]  currentWeather in
                    self?.updateInterfaceWith(weather: currentWeather)
                    self?.array = currentWeather.weatherDetail()
                }
            }
        }
    }
}
    
extension WeatherVC {
    
    func setLayout() {
        
        view.addSubview(backgroundImageView)
        view.addSubview(weatherWeek)
        view.addSubview(wheatherIconImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(searchCityButton)
        view.addSubview(cityLabel)
        view.addSubview(feelsLikeTemperatureLabel)
        view.addSubview(spiner)
        view.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: +65),
            
            cityLabel.bottomAnchor.constraint(equalTo: searchCityButton.bottomAnchor),
            cityLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            
            weatherWeek.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherWeek.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            weatherWeek.widthAnchor.constraint(equalToConstant: 45),
            weatherWeek.heightAnchor.constraint(equalToConstant: 45),
            
            searchCityButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: locationButton.bottomAnchor, multiplier: 1),
            locationButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 45),
            locationButton.heightAnchor.constraint(equalToConstant: 45),
            
            wheatherIconImageView.widthAnchor.constraint(equalToConstant: 165),
            wheatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wheatherIconImageView.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.topAnchor, multiplier: 27),
            
            temperatureLabel.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: wheatherIconImageView.bottomAnchor, multiplier: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchCityButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            searchCityButton.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchCityButton.widthAnchor.constraint(equalToConstant: 45),
            searchCityButton.heightAnchor.constraint(equalToConstant: 45),
            searchCityButton.leadingAnchor.constraint(equalToSystemSpacingAfter: cityLabel.trailingAnchor, multiplier: 1),
            
            feelsLikeTemperatureLabel.topAnchor.constraint(equalToSystemSpacingBelow: temperatureLabel.bottomAnchor, multiplier: 1),
            feelsLikeTemperatureLabel.centerXAnchor.constraint(equalTo: temperatureLabel.centerXAnchor),
            
            spiner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spiner.topAnchor.constraint(equalTo: feelsLikeTemperatureLabel.bottomAnchor, constant: 50)
        ])
    }
}
