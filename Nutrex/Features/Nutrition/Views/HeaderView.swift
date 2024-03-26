//
//  HeaderView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 25/03/2024.
//

import SwiftUI

extension NutritionDiaryScreen {
    
    struct HeaderView: View {
        @Binding var date: Date
        
        @State private var weekSlider: [[Date.WeekDay]] = []
        @State private var currentWeekIndex: Int = 1
        @State private var createWeek = false
        
        @Namespace private var animation
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8.0) {
                
                Text("DIARY")
                    .font(.customFont(font: .audiowide, size: .largeTitle, relativeTo: .largeTitle))
                
                Text(date.formatted(date: .complete, time: .omitted))
                    .font(.customFont(font: .audiowide, size: .caption, relativeTo: .caption))
                    .textScale(.secondary)
                    .foregroundStyle(.secondary)
                
                TabView(selection: $currentWeekIndex) {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        
                        WeekView(week: week,
                                 index: index,
                                 animation: animation,
                                 weekSlider: $weekSlider,
                                 currentWeekIndex: $currentWeekIndex,
                                 createWeek: $createWeek,
                                 date: $date)
                        .tag(index)
                    }
                }
                .padding(.horizontal, -16)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 100.0)
            }
            .padding(16.0)
            .hSpacing(.leading)
            .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
                // create new weeks when user reaches the next/previous week
                
                if newValue == 0 || newValue == (weekSlider.count - 1) {
                    createWeek = true
                }
            }
            .onAppear {
                if weekSlider.isEmpty {
                    let currentWeek = Date().fetchWeek()
                    
                    if let firstDate = currentWeek.first?.date {
                        weekSlider.append(firstDate.createPreviousWeek())
                    }
                    
                    weekSlider.append(currentWeek)
                    
                    if let lastDate = currentWeek.last?.date {
                        weekSlider.append(lastDate.createNextWeek())
                    }
                }
            }
        }
    }
    
}

#Preview {
    NutritionDiaryScreen.HeaderView(date: .constant(Date()))
}


