

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
