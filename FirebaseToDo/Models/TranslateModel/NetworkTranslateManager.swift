//
//  File.swift
//  Weather App
//
//  Created by Duxxless on 30.01.2022.
//

import Foundation
import UIKit

extension String {
    // Для возможности вставки русских слов в ссылку
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}

class NetworkTranslate {
    
    func fetchCurrentWord(translateCity city: String, complitionHander: @escaping (String) -> Void) {
        let stringURL = "https://api.mymemory.translated.net/get?q=\(city)&langpair=ru|en".encodeUrl
        guard let url = URL(string: stringURL) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                
                let curretTranslate = self.parceTranslateJSON(data: data)
                guard let translateCity = curretTranslate?.translateCapitalized else { return }
                complitionHander(translateCity)
                
            } else {
                if let error = error as NSError? {
                    print(error.localizedDescription)
                    
                }
            }
        })
        dataTask.resume()
    }
    
    func parceTranslateJSON(data: Data) -> CurrentCityTranslate? {
        
        let decoder = JSONDecoder()
        
        do {
            let currentTranslateData = try decoder.decode(CurrentCityTranslateData.self, from: data)
            let curentTranslate = CurrentCityTranslate(currentCityTranslateData: currentTranslateData)
            return curentTranslate
        } catch {
            // print(error.localizedDescription)
        }
        return nil
    }
}
