//
//  CurrentCityTranslate.swift
//  Weather App
//
//  Created by Duxxless on 30.01.2022.
//

import Foundation

struct CurrentCityTranslate {
    
    var translate: String
    var translateCapitalized: String {
        let text = translate
        return text
    }
    
    init?(currentCityTranslateData: CurrentCityTranslateData) {
        translate = currentCityTranslateData.responseData.translatedText.capitalized
    }
}
