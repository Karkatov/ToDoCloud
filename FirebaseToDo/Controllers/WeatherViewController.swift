

import UIKit
import CoreLocation

protocol WeatherViewControllerDelegate {
    func showErrorAlert()
}
class WeatherViewController: UIViewController {
    
    var weatherDetail = [String]()
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
        imageView.tintColor = .darkWhite()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    let blurViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
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
        label.textColor = .darkWhite()
        return label
    }()
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .darkWhite()
        return label
    }()
    let searchCityButton: UIButton = {
        let button = UIButton()
        button.pulsate(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        let searchImage = UIImage(systemName: "magnifyingglass.circle.fill")
        button.setBackgroundImage(searchImage, for: .normal)
        button.tintColor = .darkWhite()
        return button
    }()
    let detailButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        let weatherWeekImage = UIImage(systemName: "line.3.horizontal.circle.fill")
        button.setBackgroundImage(weatherWeekImage, for: .normal)
        button.tintColor = .darkWhite()
        return button
    }()
    let locationButton: UIButton = {
        let button = UIButton()
        button.pulsate(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        let locationImage = UIImage(systemName: "location.circle.fill")
        button.setBackgroundImage(locationImage, for: .normal)
        button.tintColor = .darkWhite()
        return button
    }()
    let spiner: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.style = .large
        activity.color = .darkWhite()
        activity.hidesWhenStopped = true
        return activity
    }()
    var checkCity = true
    let dataFetcherService = DataFetcherService()
    let networkTranslate = NetworkTranslate()
    let userDefaults = UserDefaults()
    let queue = DispatchQueue(label: "serial", attributes: .concurrent)
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.distanceFilter = 1000.0
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        spiner.startAnimating()
        fistUpdateUI()
    }
}

// MARK: - Methods
extension WeatherViewController {
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(blurView)
        view.addSubview(blurViewTwo)
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
            .strokeColor: .darkWhite() ?? UIColor(),
            .foregroundColor : .darkWhite() ?? UIColor(),
            .font : UIFont.boldSystemFont(ofSize: 80)
        ]
        let celciusAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 60),
            .foregroundColor : .darkWhite() ?? UIColor()
        ]
        let attributedString = NSMutableAttributedString(string: temperature, attributes: boldAttributes)
        attributedString.append(NSAttributedString(string: "℃", attributes: celciusAttributes))
        return attributedString
    }
    
    @objc func presentAlert() {
        searchCityButton.pulsate(0.7)
        presentSearchAlertController(tittle: "Введите название города", message: nil, style: .alert) { city in
            
            self.spiner.startAnimating()
            self.queue.async {
                self.dataFetcherService.fetchWeather(forCity: city) { currentWeatherData in
                    if currentWeatherData == nil {
                        self.errorAlertController()
                        return
                    }
                    guard let currentWeatherData = currentWeatherData,
                          let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                        return }
                    self.updateInterfaceWith(weather: currentWeather)
                    self.weatherDetail = currentWeather.weatherDetail()
                    self.userDefaults.set(city, forKey: "city")
                }
            }
            self.spiner.stopAnimating()
        }
    }
    
    @objc func showDetail() {
        let secondVC = DetailWeatherVC()
        secondVC.detail = weatherDetail
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @objc func findPosition() {
        locationButton.pulsate(0.7)
        locationButton.opacityAnimation()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
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
            self.weatherIconImageView.image = self.getWeatherIcon(weather.systemIconWheatherString)
            self.spiner.stopAnimating()
            self.temperatureLabel.attributedText = self.makeTemperatureText(temperature: weather.temperatureString)
            self.cityLabel.text = weather.cityName
            self.feelsLikeTemperatureLabel.text = "Ощущается как \(weather.feelsLikeTemperatureString)º"
            
            guard self.blurView.alpha == 0 else { return }
            UIView.animate(withDuration: 0.2) {
                self.blurView.alpha = 0
                self.blurView.alpha = 0.7
            }
            UIView.animate(withDuration: 0.3) {
                self.blurViewTwo.alpha = 0
                self.blurViewTwo.alpha = 0.7
            }
            self.dispatch(object: self.temperatureLabel, duration: 1)
            self.dispatch(object: self.feelsLikeTemperatureLabel, duration: 1)
            self.dispatch(object: self.cityLabel, duration: 1)
        }
    }
    
    private func dispatch(object: UILabel, duration: Double) {
        object.opacityAnimation(myDuration: duration)
    }
    
    private func fistUpdateUI() {
        queue.async {
            if let city = self.userDefaults.object(forKey: "city") as? String {
                
                self.dataFetcherService.fetchWeather(forCity: city) { currentWeatherData in
                    guard let currentWeatherData = currentWeatherData else { return }
                    let weather = CurrentWeather(currentWeatherData: currentWeatherData)!
                    self.updateInterfaceWith(weather: weather)
                    self.weatherDetail = weather.weatherDetail()
                }
            } else {
                self.findPosition()
            }
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: +65),
            
            cityLabel.centerYAnchor.constraint(equalTo: searchCityButton.centerYAnchor),
            cityLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            cityLabel.trailingAnchor.constraint(equalTo: searchCityButton.leadingAnchor, constant: -20),
            
            blurViewTwo.trailingAnchor.constraint(equalToSystemSpacingAfter: cityLabel.trailingAnchor, multiplier: 1),
            blurViewTwo.heightAnchor.constraint(equalToConstant: 40),
            blurViewTwo.widthAnchor.constraint(equalTo: cityLabel.widthAnchor, constant: 15),
            blurViewTwo.bottomAnchor.constraint(equalTo: searchCityButton.bottomAnchor),
            
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
    
    private func getWeatherIcon(_ systemNameIcon: String) -> UIImage? {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue, .clear])
        var iconImage = UIImage(systemName: "nosign", withConfiguration: config)
        
        switch systemNameIcon {
        case let str where str.contains("cloud.bolt.rain.fill") :
            iconImage = (UIImage(systemName: "cloud.bolt.rain.fill", withConfiguration: config)!)
            return iconImage
            
        case let str where str.contains("cloud.drizzle.fill") :
            iconImage = (UIImage(systemName: "cloud.drizzle.fill", withConfiguration: config)!)
            return iconImage
            
        case let str where str.contains("cloud.rain.fill") :
            iconImage = (UIImage(systemName: "cloud.rain.fill", withConfiguration: config)!)
            return iconImage
            
        case let str where str.contains("cloud.snow.fill") :
            iconImage = (UIImage(systemName: "cloud.snow.fill"))
            return iconImage
            
        case let str where str.contains("smoke.fill") :
            iconImage = (UIImage(systemName: "smoke.fill"))
            return iconImage
            
        case let str where str.contains("sun.min.fill") :
            let config = UIImage.SymbolConfiguration(paletteColors: [.systemYellow, .clear, .clear])
            iconImage = (UIImage(systemName: "sun.min.fill", withConfiguration: config)!)
            return iconImage
            
        case let str where str.contains("cloud.fill") :
            iconImage = (UIImage(systemName: "cloud.fill"))
            return iconImage
            
        default:
            break
        }
        return iconImage
    }
}

// MARK: - CLLocationManagerDlegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        spiner.startAnimating()
        var currentCity = cityLabel.text
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.spiner.startAnimating()
        queue.async {
            self.dataFetcherService.fetchCurrentWeatherForCoordinate(forLatitude: latitude, longitude: longitude) { currentWeatherData in
                guard let currentWeatherData = currentWeatherData,
                      let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                    return }
                self.updateInterfaceWith(weather: currentWeather)
                self.weatherDetail = currentWeather.weatherDetail()
                self.userDefaults.set(currentWeather.cityName, forKey: "city")
                self.spiner.stopAnimating()
            }
        }
        self.errorAlertController()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension WeatherViewController: WeatherViewControllerDelegate {
    func showErrorAlert() {
        self.errorAlertController()
    }
}

// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func presentSearchAlertController(tittle: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let searchAlertController = UIAlertController(title: tittle,
                                                      message: message,
                                                      preferredStyle: style)
        searchAlertController.addTextField { cityTextField in
            let placeholder = ["Moscow", "Saint-Petersburg", "Los Angeles", "Monaco", "Velikiy Novgorod"]
            cityTextField.delegate = self
            cityTextField.placeholder = placeholder.randomElement()
            cityTextField.text = cityTextField.text?.capitalized
            cityTextField.clearButtonMode = .whileEditing // Кнопка «Очистить» при редактировании
            cityTextField.clearButtonMode = .unlessEditing // не появляется во время редактирования, кнопка редактирования появляется после редактирования
            cityTextField.clearButtonMode = .always // Всегда показывать кнопку очистки
        }
        
        let searchAction = UIAlertAction(title: "Найти", style: .default) { [unowned self] _ in
            let textField = searchAlertController.textFields?.first
            guard let cityName = textField?.text else { return }
            let city = cityName.split(separator: " ").joined(separator: "%20")
            self.dataFetcherService.fetchCurrentWord(translateCity: city) { translate in
                guard let translate = translate,
                      let city = CityTranslate(currentCityTranslateData: translate)
                else { return }
                completionHandler(city.translateCapitalized)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        searchAlertController.addAction(searchAction)
        searchAlertController.addAction(cancelAction)
        searchAlertController.preferredAction = cancelAction
        present(searchAlertController, animated: true, completion: nil)
    }
    
    func errorAlertController() {
        DispatchQueue.main.async {
            let errorAlertController = UIAlertController(title: "Упс...", message: "Такого города мы не нашли🥲", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
            errorAlertController.addAction(cancelAction)
            self.present(errorAlertController, animated: true, completion: nil)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let capitalizedText = textField.text?.capitalized
        textField.text = capitalizedText
        return true
    }
}
