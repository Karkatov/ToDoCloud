//
//  CurrentCityTranslate.swift
//  Weather App
//
//  Created by Duxxless on 30.01.2022.
//

import Foundation
import UIKit

struct CurrentCityTranslateData: Codable {
    
    let responseData: ResponseData

    enum CodingKeys: String, CodingKey {
        case responseData
    }
}

// MARK: - ResponseData
struct ResponseData: Codable {
    let translatedText: String
    
}

