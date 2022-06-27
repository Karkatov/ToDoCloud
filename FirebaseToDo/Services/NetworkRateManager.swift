

import Alamofire
import UIKit

class NetworkRateManager {
    
    let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    
    func fetchGenericJSONData<T: Codable>(response: @escaping (T?) -> Void) {
        request { data, error in
            if let error = error {
                print("Error received requesting data", error)
                response(nil)
            }
            guard let data = data else { return }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    func request(complitionHandler: @escaping (Data?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).validate().responseJSON { dataResponse in
            switch dataResponse.result {
            case .success(_) :
                complitionHandler(dataResponse.data, dataResponse.error)
            case .failure(let error) :
                print(error)
            }
        }
    }
    func decodeJSON<T: Codable>(type: T.Type, from: Data?) -> T? {
        guard let data = from else { return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch let jsonError {
            print("Error", jsonError)
            return nil
        }
    }
}
