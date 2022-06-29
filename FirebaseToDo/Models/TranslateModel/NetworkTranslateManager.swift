

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
                    guard let data = dataResponse.data else { return }
                    let currentTranslate = self.parceTranslateJSON(data: data)
                    guard let cityTranslate = currentTranslate?.translate else { return }
                    complitionHander(cityTranslate)
                case .failure(let error):
                    print("Error 3", error.localizedDescription)
                }
            }
    }
    
    func parceTranslateJSON(data: Data) -> CityTranslate? {
        
        let decoder = JSONDecoder()
        
        do {
            let currentTranslateData = try decoder.decode(CityTranslateData.self, from: data)
            let curentTranslate = CityTranslate(currentCityTranslateData: currentTranslateData)
            return curentTranslate
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
