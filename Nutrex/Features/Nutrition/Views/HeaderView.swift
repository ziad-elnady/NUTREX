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
        
//        @Namespace private var animation
        
        let logButtonPressed: () -> Void
        
        var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    Text("DIARY")
                        .impactFontHeaderStyle(letterSpacing: 2)
                    
                    Text(date.formatted(date: .complete, time: .omitted))
                        .bodyFontStyle()
                        .textScale(.secondary)
                        .foregroundStyle(.secondary)
                }
                .hSpacing(.leading)
                .overlay(alignment: .trailing) {
                   ProfileButton()
                }
                
                TabView(selection: $currentWeekIndex) {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        
                        WeekView(week: week,
                                 index: index,
//                                 animation: animation,
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

// MARK: - VIEW -
extension NutritionDiaryScreen.HeaderView {
    
    @ViewBuilder
    private func ProfileButton() -> some View {
        Button {
            logButtonPressed()
        } label: {
            HStack(spacing: 12.0) {
//                Image(systemName: "fork.knife.circle")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24.0, height: 24.0)
//                    .background {
//                        Capsule()
//                        .fill(.blue.gradient)
//                        .frame(width: 32.0, height: 32.0)
//                    }
                
                Text("log")
                    .font(.customFont(font: .audiowide))
                    .padding(.horizontal)
            }
            .padding(8.0)
            .background {
                Capsule()
                    .stroke(.gray.opacity(0.35))
    //                                .fill(.white)
            }
        }
        .foregroundStyle(.primary)
    }
    
}

#Preview {
    NutritionDiaryScreen.HeaderView(date: .constant(Date())) {
        
    }
}


