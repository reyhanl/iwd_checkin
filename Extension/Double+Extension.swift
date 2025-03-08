//
//  Double+Extension.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

extension Double{
    func getCurrency(_ useLocale: Bool = true) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        if useLocale{
            currencyFormatter.locale = Locale.current

        }

        let priceString = currencyFormatter.string(from: NSNumber(value: self))!
        return priceString
    }
}
