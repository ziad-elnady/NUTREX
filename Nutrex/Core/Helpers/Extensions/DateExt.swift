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
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
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
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else { return [] }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(previousDate)
    }
    
    struct WeekDay: Identifiable {
        let id: UUID = .init()
        var date: Date
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
