//
//  NetworkRateManager.swift
//  СurrencyRate
//
//  Created by Duxxless on 25.02.2022.
//

import Alamofire
import UIKit

class NetworkRateManager {
    
    func fetchCurrencyRate(complitionHandler: @escaping ([[String]]) -> Void) {
        
        let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(_) :
                    let decoder = JSONDecoder()
                    do {
                        let data = try decoder.decode(CurrencyRateData.self, from: dataResponse.data!)
                        let currencyRate = CurrencyRate(currentRateData: data)
                        complitionHandler(currencyRate.valutes)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                case .failure(let error) :
                    print(error)
                }
                
                
//            if (200..<300).contains(statusCode) {
//                guard let value = dataResponse.value else { return }
//                print(value)
//            }
//            guard let error = dataResponse.error else { return }
//            print(error)
            
            
        }
        
        
    }
}
