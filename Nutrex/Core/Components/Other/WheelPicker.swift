//
//  WheelPicker.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 16/03/2024.
//

import SwiftUI

struct WheelPicker: View {
    var config: Config
    @Binding var value: CGFloat
    
    @State private var isLoaded: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let horizontalPadding = size.width / 2
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: config.spacing) {
                    let totalSteps = config.steps * config.count
                    
                    ForEach(config.startValue...totalSteps, id: \.self) { index in
                        let remainder = index % config.steps
                        
                        Divider()
                            .background(remainder == 0 ? Color.primary : .gray)
                            .frame(height: remainder == 0 ? 20 : 10, alignment: .center)
                            .frame(maxHeight: 10, alignment: .bottom)
                            .overlay(alignment: .bottom) {
                                if remainder == 0 && config.showText {
                                    Text("\(index / config.steps)")
                                        .font(.customFont(font: .audiowide, size: .caption, relativeTo: .caption))
                                        .fontWeight(.semibold)
                                        .textScale(.secondary)
                                        .fixedSize()
                                        .offset(y: 20)
                                }
                            }
                    }
                }
                .frame(height: size.height)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding<Int?>(get: {
                let position: Int? = isLoaded ? (Int(value) * config.steps) / config.multiplier : nil
                return position
            }, set: { newValue in
                if let newValue {
                    value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
                }
            }))
            .overlay(alignment: .center) {
                Rectangle()
                    .frame(width: 1.0, height: 40.0)
                    .padding(.bottom, 30.0)
            }
            .safeAreaPadding(.horizontal, horizontalPadding)
            .onAppear {
                if !isLoaded { isLoaded = true }
            }
        }
    }
    
    struct Config: Equatable {
        var count: Int
        var startValue: Int
        var steps: Int = 10
        var spacing: CGFloat = 5
        var multiplier: Int = 10
        var showText: Bool = true
    }
}

#Preview {
//    NavigationStack {
//        VStack {
//            WheelPicker(config: WheelPicker.Config.init(count: 30, startValue: 40), value: .constant(10))
//                .frame(height: 60)
//        }
//        .navigationTitle("Wheel Picker")
//    }
    TestView()
}

struct TestView: View {
    @State private var config: WheelPicker.Config = .init(count: 120, startValue: 30)
    @State private var value: CGFloat = 50.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Weight")
                    .font(.customFont(font: .audiowide, size: .title, relativeTo: .title))
                    .foregroundStyle(.nxAccent)
                    .padding(.bottom)
                
                HStack(alignment: .lastTextBaseline, spacing: 4.0) {
                    Text(verbatim: "\(value)")
                        .font(.customFont(font: .audiowide, size: .largeTitle))
                        .contentTransition(.numericText(value: value))
                        .animation(.snappy, value: value)
                    
                    Text("kg")
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 32)
                
                WheelPicker(config: config, value: $value)
                    .frame(height: 60)
            }
            .navigationTitle("Wheel Picker")
        }
    }
}
