
//  ViewController.swift
//  Weather App
//
//  Created by Duxxless on 21.01.2022.
//

import UIKit

class WeatherVC: UIViewController {
    
    var array = [String]()
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "weather")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "nil")
        imageView.tintColor = UIColor(named: "DarkWhite")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor(named: "DarkWhite")
        return label
    }()
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 34)
        label.textColor = UIColor(named: "DarkWhite")
        return label
    }()
    let searchCityButton: UIButton = {
        let button = UIButton()
        button.pulsate(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        let searchImage = UIImage(systemName: "magnifyingglass.circle.fill")
        button.setBackgroundImage(searchImage, for: .normal)
        button.tintColor = UIColor(named: "DarkWhite")
        return button
    }()
    let detailButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        let weatherWeekImage = UIImage(systemName: "line.3.horizontal.circle.fill")
        button.setBackgroundImage(weatherWeekImage, for: .normal)
        button.tintColor = UIColor(named: "DarkWhite")
        return button
    }()
    let locationButton: UIButton = {
        let button = UIButton()
        button.pulsate(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        let locationImage = UIImage(systemName: "location.circle.fill")
        button.setBackgroundImage(locationImage, for: .normal)
        button.tintColor = UIColor(named: "DarkWhite")
        return button
    }()
    let spiner: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.style = .large
        activity.color = UIColor(named: "DarkWhite")
        activity.hidesWhenStopped = true
        return activity
    }()
    let networkWeatherManager = NetworkWeatherManager()
    let networkTranslate = NetworkTranslate()
    let userDefaults = UserDefaults()
    let queue = DispatchQueue(label: "serial", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        spiner.startAnimating()
        fistUpdateUI()
    }
}

// MARK: - Methods
extension WeatherVC {
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(blurView)
        view.addSubview(detailButton)
        view.addSubview(weatherIconImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(searchCityButton)
        view.addSubview(cityLabel)
        view.addSubview(feelsLikeTemperatureLabel)
        view.addSubview(spiner)
        view.addSubview(locationButton)
        setButtons()
        setLayout()
    }
    private func setButtons() {
        searchCityButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(findPosition), for: .touchUpInside)
    }
    
    private func makeTemperatureText(temperature: String) -> NSAttributedString {
        let boldAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor: UIColor(named: "DarkWhite") ?? UIColor(),
            .foregroundColor : UIColor(named: "DarkWhite") ?? UIColor(),
            .font : UIFont.boldSystemFont(ofSize: 80)
        ]
        let celciusAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 60),
            .foregroundColor : UIColor(named: "DarkWhite") ?? UIColor()
        ]
        let attributedString = NSMutableAttributedString(string: temperature, attributes: boldAttributes)
        attributedString.append(NSAttributedString(string: "℃", attributes: celciusAttributes))
        return attributedString
    }
    
    // MARK: - Methods
    @objc func presentAlert() {
        searchCityButton.pulsate(0.7)
        presentSearchAlertController(tittle: "Введите название города", message: nil, style: .alert) { city in
            DispatchQueue.main.async {
                self.spiner.startAnimating()
            }
            //UserDefaults
            self.userDefaults.set(city, forKey: "city")
            self.networkWeatherManager.fetchCurrentWeather(forCity: city) { [unowned self] currentWeather in
                self.updateInterfaceWith(weather: currentWeather)
                self.array = currentWeather.weatherDetail()
            }
            self.networkWeatherManager.boolComplition = { [unowned self] error in
                if error == false {
                    self.errorAlertController()
                    DispatchQueue.main.async {
                        self.spiner.stopAnimating()
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
        locationButton.pulsate(0.7)
        locationButton.opacityAnimation()
        //locationButton.shake()
    }
    
    private func showAnimation() {
        self.weatherIconImageView.pulsateImage()
        dispatch(object: temperatureLabel, duration: 0.3)
        dispatch(object: feelsLikeTemperatureLabel, duration: 0.5)
    }
    
    private func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.detailButton.isHidden = false
            self.detailButton.pulsate(0.7)
            self.weatherIconImageView.pulsateImage()
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconWheatherString)
            self.spiner.stopAnimating()
            self.temperatureLabel.attributedText = self.makeTemperatureText(temperature: weather.temperatureString)
            self.cityLabel.text = weather.cityName
            self.feelsLikeTemperatureLabel.text = "Ощущается как \(weather.feelsLikeTemperatureString)º"
            
            if self.blurView.alpha == 0 {
                UIView.animate(withDuration: 0.5) {
                    self.blurView.alpha = 0
                    self.blurView.alpha = 0.4
                }
            }
        }
        dispatch(object: self.temperatureLabel, duration: 1)
        dispatch(object: self.feelsLikeTemperatureLabel, duration: 1)
    }
    
    private func dispatch(object: UILabel, duration: Double) {
        DispatchQueue.main.sync {
            object.opacityAnimation(myDuration: duration)
        }
    }
    
    private func fistUpdateUI() {
        queue.async {
            if let city = self.userDefaults.object(forKey: "city") as? String {
                self.networkWeatherManager.fetchCurrentWeather(forCity: city) { [unowned self]  currentWeather in
                    self.updateInterfaceWith(weather: currentWeather)
                    self.array = currentWeather.weatherDetail()
                    return
                }
            } else {
                self.networkWeatherManager.fetchCurrentWeather(forCity: "Moscow") { [unowned self]  currentWeather in
                    self.updateInterfaceWith(weather: currentWeather)
                    self.array = currentWeather.weatherDetail()
                }
            }
        }
    }

    private func setLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: +65),
            
            cityLabel.bottomAnchor.constraint(equalTo: searchCityButton.bottomAnchor),
            cityLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            
            detailButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            detailButton.widthAnchor.constraint(equalToConstant: 45),
            detailButton.heightAnchor.constraint(equalToConstant: 45),
            
            searchCityButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: locationButton.bottomAnchor, multiplier: 1),
            locationButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 45),
            locationButton.heightAnchor.constraint(equalToConstant: 45),
            
            blurView.widthAnchor.constraint(equalToConstant: 220),
            blurView.heightAnchor.constraint(equalToConstant: 320),
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurView.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.topAnchor, multiplier: 18),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 165),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.topAnchor, multiplier: 27),
            
            temperatureLabel.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: weatherIconImageView.bottomAnchor, multiplier: 10),
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
