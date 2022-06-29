

import Foundation

struct CityTranslate {
    
    var translate: String
    var translateCapitalized: String {
        let text = translate
        return text
    }
    
    init?(currentCityTranslateData: CityTranslateData) {
        translate = currentCityTranslateData.responseData.translatedText.capitalized
    }
}
