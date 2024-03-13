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
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
