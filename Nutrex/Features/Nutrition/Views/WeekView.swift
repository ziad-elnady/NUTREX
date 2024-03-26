//
//  WeekView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 25/03/2024.
//

import SwiftUI

extension NutritionDiaryScreen.HeaderView {
    
    struct WeekView: View {
        let week: [Date.WeekDay]
        let index: Int
        let animation: Namespace.ID
        
        @Binding var weekSlider: [[Date.WeekDay]]
        @Binding var currentWeekIndex: Int
        @Binding var createWeek: Bool
        
        @Binding var date: Date
        
        var body: some View {
            HStack {
                ForEach(week) { day in
                    DayView(day: day, animation: animation, date: $date)
                }
            }
            .background {
                GeometryReader {
                    let minX = $0.frame(in: .global).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self) { value in
                            if value.rounded() == 16.0 && createWeek {
                                paginateWeek()
                                createWeek = false
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        
        private func paginateWeek() {
            if weekSlider.indices.contains(currentWeekIndex) {
                if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                    weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                    weekSlider.removeLast()
                    currentWeekIndex = 1
                }
                
                if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                    weekSlider.append(lastDate.createNextWeek())
                    weekSlider.removeFirst()
                    currentWeekIndex = weekSlider.count - 2
                }
            }
        }
        
    }
}


//#Preview {
//    WeekView()
//}
