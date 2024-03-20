//
//  DateExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import Foundation

extension Date {
    var onlyDate: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
    
    static func createDate(day: Int, month: Int, year: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)
    }
    
    func age() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: self, to: currentDate)
        if let ageYears = ageComponents.year {
            return ageYears
        } else {
            return 0
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
