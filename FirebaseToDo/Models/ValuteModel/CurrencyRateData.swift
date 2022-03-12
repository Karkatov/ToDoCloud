//
//  CurrencyRateData.swift
//  СurrencyRate
//
//  Created by Duxxless on 25.02.2022.
//

import Foundation

// MARK: - CurrencyRateData
struct CurrencyRateData: Codable {
    let date, previousDate: String
    let previousURL: String
    let timestamp: String
    let valute: [String: Valute]

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
}

// MARK: - Valute
struct Valute: Codable {
    let charCode: String
    let nominal: Int
    let name: String
    let value, previous: Double

    enum CodingKeys: String, CodingKey {
       
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
}
