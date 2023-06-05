//
//  Currency.swift
//  CurrencyExchangeGBM
//
//  Created by Steven Wijaya on 05.06.2023.
//

import Foundation

struct Currency: Identifiable {
    let id: UUID = UUID()
    var name: String
    var short: String
    var rate: Double
    var day: Int
    
    enum ECurrency: String, CaseIterable {
        case USD, EUR, ISK, NOK, IDR, JPY, CNY
    }
}
