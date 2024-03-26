//
//  DayView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 25/03/2024.
//

import SwiftUI

extension NutritionDiaryScreen.HeaderView {
    
    struct DayView: View {
        let day: Date.WeekDay
        let animation: Namespace.ID
        @Binding var date: Date
        
        var body: some View {
            VStack(spacing: 8.0) {
                Text(day.date.format("E"))
                    .font(.customFont(font: .audiowide, size: .callout, relativeTo: .callout))
                    .foregroundStyle(.secondary)
                    .textScale(.secondary)
                
                Text(day.date.format("dd"))
                    .font(.customFont(font: .audiowide, size: .caption, relativeTo: .caption))
                    .foregroundStyle(isSameDate(day.date, date) ? .black : .secondary)
                    .textScale(.secondary)
                    .frame(width: 38.0, height: 38.0)
                    .background {
                        if isSameDate(day.date, date) {
                            Circle()
                                .fill(.primary)
                                .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                        } else {
                            Circle()
                                .stroke(.secondary, lineWidth: 0.5)
                        }
                        
                        if day.date.isToday {
                            Circle()
                                .fill(.white)
                                .frame(width: 5.0, height: 5.0)
                                .vSpacing(.bottom)
                                .offset(y: 16)
                        }
                    }
            }
            .hSpacing(.center)
            .contentShape(.rect)
            .onTapGesture {
                withAnimation {
                    date = day.date
                }
            }
        }
    }
    
}

#Preview {
    @Namespace var animation
    
    return NutritionDiaryScreen
        .HeaderView
        .DayView(day: Date.WeekDay(date: .now), animation: animation,
                 date: .constant(Date()))
}
