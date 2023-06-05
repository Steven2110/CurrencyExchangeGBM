//
//  CEGPicker.swift
//  CurrencyExchangeGBM
//
//  Created by Steven Wijaya on 05.06.2023.
//

import SwiftUI

struct CEGPicker: View {
    
    @Binding var currency: Currency.ECurrency
    
    var body: some View {
        Picker("", selection: $currency) {
            ForEach(Currency.ECurrency.allCases, id: \.self) { currency in
                Text("\(currency.rawValue) - \(getInitialPrice(of: currency), specifier: "%.3f") RUB")
            }
        }.labelsHidden()
    }
}

struct CEGPicker_Previews: PreviewProvider {
    static var previews: some View {
        CEGPicker(currency: .constant(.USD))
    }
}
