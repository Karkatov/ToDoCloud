//
//  ViewController + AlertController.swift
//  Weather App
//
//  Created by Duxxless on 23.01.2022.
//

import UIKit

extension WeatherVC: UITextFieldDelegate {
    
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
        
        let searchAction = UIAlertAction(title: "Найти",
                                         style: .default) { action in
            let textField = searchAlertController.textFields?.first
            guard let cityName = textField?.text else { return }
            let city = cityName.split(separator: " ").joined(separator: "%20")
            
            //self.networkWeatherManager.fetchCurrentWeather(forCity: "Moscow")
            self.networkTranslate.fetchCurrentWord(translateCity: city) { translateOfCity in
                completionHandler(translateOfCity)
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
            let errorAlertController = UIAlertController(title: "Упс...", message: "Такого города мы не нашли!🥲", preferredStyle: .alert)
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
