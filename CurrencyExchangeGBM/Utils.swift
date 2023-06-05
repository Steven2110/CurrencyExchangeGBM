//
//  Utils.swift
//  CurrencyExchangeGBM
//
//  Created by Steven Wijaya on 05.06.2023.
//

import Foundation

func getCurrencyName(of currency: Currency.ECurrency) -> String {
    switch currency {
    case .USD:
        return "United States Dollar"
    case .EUR:
        return "Euro"
    case .ISK:
        return "Icelandic Króna"
    case .NOK:
        return "Norwegian Krone"
    case .IDR:
        return "Indonesian Rupiah"
    case .JPY:
        return "Japanese Yen"
    case .CNY:
        return "CNY"
    }
}

func getCurrencyShort(of currency: Currency.ECurrency) -> String {
    currency.rawValue
}

func getInitialPrice(of currency: Currency.ECurrency) -> Double {
    // Initial Price per 5th June
    switch currency {
    case .USD:
        return 81.48
    case .EUR:
        return 87.01
    case .ISK:
        return 0.58
    case .NOK:
        return 7.35
    case .IDR:
        return 0.0055
    case .JPY:
        return 0.58
    case .CNY:
        return 11.42
    }
}
