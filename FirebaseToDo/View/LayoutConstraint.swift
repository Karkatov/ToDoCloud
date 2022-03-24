//
//  ViewController.swift
//  Weather App
//
//  Created by Duxxless on 20.02.2022.
//

import UIKit
import SnapKit

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

extension LoginViewController {
    func setLayout() {
    
        backgroundImageView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height)
        view.addSubview(backgroundImageView)
        
        nameAppLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                                    y: 150,
                                    width: 310,
                                    height: 40)
        view.addSubview(nameAppLabel)
        
        emailTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                               y: view.bounds.size.height / 2 - 25,
                               width: 300,
                               height: 40)
        view.addSubview(emailTF)
        
        passwordTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                  y: view.bounds.size.height / 2 + 25,
                                  width: 300,
                                  height: 40)
        view.addSubview(passwordTF)
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                        y: passwordTF.frame.origin.y + 50,
                                        width: 300,
                                        height: 30)
        view.addSubview(warningTextLabel)
        
        loginButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                   y: passwordTF.frame.origin.y + 100 ,
                                   width: 300,
                                   height: 40)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                      y: passwordTF.frame.origin.y + 150,
                                      width: 300,
                                      height: 40)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        spiner.frame = CGRect(x: view.bounds.size.width / 2 - 25 , y: nameAppLabel.frame.origin.y + 100, width: 50, height: 50)
        view.addSubview(spiner)
    }
}
