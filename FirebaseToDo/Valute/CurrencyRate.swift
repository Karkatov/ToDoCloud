//
//  CurrencyRate.swift
//  СurrencyRate
//
//  Created by Duxxless on 26.02.2022.
//

import Foundation

struct CurrencyRate {
    
    var valutes: [[String]] = []
    
    var name: String = ""
    var nominal: Int = 0
    var value: Double = 0
    var valueString: String {
        let valueDouble = value / Double(nominal)
        let valueStrring = String(format: "%.02f", valueDouble)
        return valueStrring
    }
    
    init(currentRateData: CurrencyRateData) {
        
        let valutesDetail = currentRateData.valute.values
        for oneValute in valutesDetail {
            var valute = [String]()
            self.name = oneValute.name
            self.nominal = oneValute.nominal
            self.value = oneValute.value
            valute.append(oneValute.charCode)
            valute.append(oneValute.name)
            valute.append(valueString)
            print(oneValute.charCode)
            valutes.append(valute)
        }
        print(valutes)
    }
}
