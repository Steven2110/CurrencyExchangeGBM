//
//  CEGViewModel.swift
//  CurrencyExchangeGBM
//
//  Created by Steven Wijaya on 05.06.2023.
//

import Foundation
import GameplayKit

final class CEGViewModel: ObservableObject {
    
    @Published var exchangeRates: [Currency] = [Currency]()
    
    private var firstCurrency: Currency.ECurrency = .USD
    private var firstCurrencyName: String = ""
    private var firstCurrencyShort: String = ""
    private var firstCurrencyCurrentRate: Double = 0.0
    
    private var secondCurrency: Currency.ECurrency = .EUR
    private var secondCurrencyName: String = ""
    private var secondCurrencyShort: String = ""
    private var secondCurrencyCurrentRate: Double = 0.0
    
    private var day: Int = 1
    
    private var k: Double = 0.05
    
    func inputInitialRate(firstCurrency: Currency.ECurrency, secondCurrency: Currency.ECurrency) {
        self.firstCurrency = firstCurrency
        self.secondCurrency = secondCurrency
        
        var firstC: Currency
        var secondC: Currency
        
        firstCurrencyName = getCurrencyName(of: firstCurrency)
        firstCurrencyShort = getCurrencyShort(of: firstCurrency)
        firstCurrencyCurrentRate = getInitialPrice(of: firstCurrency)
        firstC = Currency(
            name: firstCurrencyName,
            short: firstCurrencyShort,
            rate: firstCurrencyCurrentRate,
            day: day
        )
        
        secondCurrencyName = getCurrencyName(of: secondCurrency)
        secondCurrencyShort = getCurrencyShort(of: secondCurrency)
        secondCurrencyCurrentRate = getInitialPrice(of: secondCurrency)
        secondC = Currency(
            name: secondCurrencyName,
            short: secondCurrencyShort,
            rate: secondCurrencyCurrentRate,
            day: day
        )
        
        exchangeRates.append(firstC)
        exchangeRates.append(secondC)
    }
    
    func startPrediction() {
        day += 1
        
        var firstC: Currency
        var secondC: Currency
        
        firstCurrencyCurrentRate = predictRate(initialPrice: firstCurrencyCurrentRate)
        firstC = Currency(
            name: firstCurrencyName,
            short: firstCurrencyShort,
            rate: firstCurrencyCurrentRate,
            day: day
        )
        
        secondCurrencyCurrentRate = predictRate(initialPrice: secondCurrencyCurrentRate)
        secondC = Currency(
            name: secondCurrencyName,
            short: secondCurrencyShort,
            rate: secondCurrencyCurrentRate,
            day: day
        )
        
        exchangeRates.append(firstC)
        exchangeRates.append(secondC)
    }
    
    private func getWienerProcess() -> Double {
        // Using Gaussian Normal Random Distribution
        let random = GKRandomSource()
        let gaussian = GKGaussianDistribution(randomSource: random, lowestValue: 0, highestValue: 100000)
        
        let x1: Double = Double(gaussian.nextUniform())
        let x2: Double = Double(gaussian.nextUniform())
        print(sqrt(-2 * log(x1)) * cos(2 * Double.pi * x2))
        return sqrt(-2 * log(x1)) * cos(2 * Double.pi * x2)
    }
    
    private func predictRate(initialPrice: Double) -> Double {
        let muStdDt = (mu - std * std / 2) * dt
        let stdWeiner = std * getWienerProcess()
        let argument = muStdDt + stdWeiner
        let exponent = exp(argument)
        print("Exp: \(exponent)")
         return initialPrice * exponent
    }
    
    func getCurrentDay() -> Int {
        day
    }
    
    func getCurrentFirstCurrencyRate() -> Double {
        firstCurrencyCurrentRate
    }
    
    func getCurrentSecondCurrencyRate() -> Double {
        secondCurrencyCurrentRate
    }
    
    func getFirstCurrencyProfit() -> Double {
        if getCurrentFirstCurrencyRate() == 0.0 {
            return 0.0
        } else {
            return getCurrentFirstCurrencyRate() - getInitialPrice(of: firstCurrency)
        }
    }
    
    func getSecondCurrencyProfit() -> Double {
        if getCurrentSecondCurrencyRate() == 0.0 {
            return 0.0
        } else {
            return getCurrentSecondCurrencyRate() - getInitialPrice(of: secondCurrency)
        }
    }
    
    func reset() {
        firstCurrency = .USD
        firstCurrencyName = ""
        firstCurrencyShort = ""
        firstCurrencyCurrentRate = 0.0
        
        secondCurrency = .EUR
        secondCurrencyName = ""
        secondCurrencyShort = ""
        secondCurrencyCurrentRate = 0.0
        
        day = 1
        
        exchangeRates.removeAll()
    }
    
    func getDomainLength() -> Int {
        exchangeRates.count / 2 + 1
    }
    
}
