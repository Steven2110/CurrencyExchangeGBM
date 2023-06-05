//
//  CEGMainView.swift
//  CurrencyExchangeGBM
//
//  Created by Steven Wijaya on 05.06.2023.
//

import SwiftUI
import Charts

struct CEGMainView: View {
    
    @StateObject private var vm: CEGViewModel = CEGViewModel()
    
    @State private var firstCurrency: Currency.ECurrency = .USD
    @State private var secondCurrency: Currency.ECurrency = .EUR
    
    @State private var timer: Timer? = nil
    private let timestep: Double = 1.0
    
    @State private var firstLaunch: Bool = true
    @State private var isOnGoing: Bool = false
    
    var body: some View {
        HSplitView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Pick first currency")
                    CEGPicker(currency: $firstCurrency)
                }
                VStack(alignment: .leading) {
                    Text("Pick second currency")
                    CEGPicker(currency: $secondCurrency)
                }
                HStack {
                    startButton
                    stopButton
                    resetButton
                }
                Divider()
                Text("Information center - Day \(vm.getCurrentDay())")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(getCurrencyName(of: firstCurrency)) - \(getCurrencyShort(of: firstCurrency))").font(.title2)
                        Text("Initial price: \(getInitialPrice(of: firstCurrency), specifier: "%.3f") RUB")
                        Text("Current Price: \(vm.getCurrentFirstCurrencyRate(), specifier: "%.3f") RUB")
                        Text("Current profit: \(vm.getFirstCurrencyProfit(), specifier: "%.3f") RUB")
                    }
                }.padding()
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(getCurrencyName(of: secondCurrency)) - \(getCurrencyShort(of: secondCurrency))").font(.title2)
                        Text("Initial price: \(getInitialPrice(of: secondCurrency), specifier: "%.3f") RUB")
                        Text("Current Price: \(vm.getCurrentSecondCurrencyRate(), specifier: "%.3f") RUB")
                        Text("Current profit: \(vm.getSecondCurrencyProfit(), specifier: "%.3f") RUB")
                    }
                }.padding()
            }
            .padding()
            .frame(width: 500)
            .frame(maxHeight: .infinity)
            VStack {
                Chart(vm.exchangeRates) { currencyRate in
                    LineMark(x: .value("Day", currencyRate.day), y: .value("Rate", currencyRate.rate))
                        .foregroundStyle(by: .value("Currency", currencyRate.short))
                    PointMark(x: .value("Day", currencyRate.day), y: .value("Price", currencyRate.rate))
                        .annotation {
                            Text("\(currencyRate.rate, specifier: "%.3f")")
                        }
                        .foregroundStyle(by: .value("Currency", currencyRate.short))
                }
                .chartXScale(domain: 0...vm.getDomainLength())
                .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct CEGMainView_Previews: PreviewProvider {
    static var previews: some View {
        CEGMainView()
    }
}

extension CEGMainView {
    private var startButton: some View {
        Button {
            if firstLaunch {
                vm.inputInitialRate(firstCurrency: firstCurrency, secondCurrency: secondCurrency)
                firstLaunch = false
            }
            
            if !isOnGoing {
                timer = Timer.scheduledTimer(withTimeInterval: timestep, repeats: true) { _ in
                    vm.startPrediction()
                }
                isOnGoing = true
            }
        } label: {
            Text("Start timer")
        }
    }
    
    private var stopButton: some View {
        Button {
            isOnGoing = false
            timer?.invalidate()
        } label: {
            Text("Stop timer")
        }
    }
    
    private var resetButton: some View {
        Button {
            isOnGoing = false
            timer = nil
            firstLaunch = true
            vm.reset()
        } label: {
            Text("Reset")
        }
    }
}
