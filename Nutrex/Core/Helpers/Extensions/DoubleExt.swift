//
//  DoubleExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 09/04/2024.
//

import Foundation

extension Double {
    func formatCalories() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func formatGrams() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func formattedNumber() -> String {
        let stringValue = String(format: "%.1f", self)
        if let formattedValue = Double(stringValue) {
            if formattedValue == rounded() {
                return String(Int(formattedValue))
            } else {
                return stringValue
            }
        }
        return stringValue
    }
}
