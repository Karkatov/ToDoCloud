//
//  File.swift
//  Weather App
//
//  Created by Duxxless on 30.01.2022.
//

import Foundation
import Alamofire

class NetworkTranslate {
    
    func fetchCurrentWord(translateCity city: String, complitionHander: @escaping (String) -> Void) {
        let stringURL = "https://api.mymemory.translated.net/get?q=\(city)&langpair=ru|en".encodeUrl
        guard let url = URL(string: stringURL) else { return }
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success :
                    let decoder = JSONDecoder()
                    let data = try? decoder.decode(CurrentCityTranslateData.self, from: dataResponse.data!)
                    let currentTranslate = CurrentCityTranslate(currentCityTranslateData: data!)!
                    complitionHander(currentTranslate.translate)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func parceTranslateJSON(data: Data) -> CurrentCityTranslate? {
        
        let decoder = JSONDecoder()
        
        do {
            let currentTranslateData = try decoder.decode(CurrentCityTranslateData.self, from: data)
            let curentTranslate = CurrentCityTranslate(currentCityTranslateData: currentTranslateData)
            return curentTranslate
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
