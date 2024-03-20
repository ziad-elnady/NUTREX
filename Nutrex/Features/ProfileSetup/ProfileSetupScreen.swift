//
//  ProfileSetupScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct ProfileSetupScreen: View {
    
    enum MetricType: String, CaseIterable {
        case cm = "cm"
        case inch = "inch"
    }
    
    enum WeightType: String, CaseIterable {
        case lb = "lb"
        case kg = "kg"
    }
    
    struct ProfileSetupScreenConfig {
        var setupProgress   = 0
        var isLoading       = false
        
        var selectedGender: Gender          = .male
        var dateOfBirth: Date               =  Date.createDate(day: 1, month: 1, year: 1999)?.onlyDate ?? Date.now.onlyDate
        var bodyType: BodyType              = .ectomorph
        var selectedGoal: Goal              = .maintain
        var activityLevel: ActivityLevel    = .sedentary
                
        var metricType: MetricType          = .cm
        var weightType: WeightType          = .kg
        
        var heightValue: CGFloat = 170
        var heightWheelConfig: WheelPicker.Config = .init(count: 250, startValue: 170, multiplier: 1)
        
        var weightValue: CGFloat = 70
        var weightWheelConfig: WheelPicker.Config = .init(count: 180, startValue: 70, multiplier: 1)
        
        var xOffset: CGFloat = 500
        
        var isProfileComplete: Bool {
            setupProgress == 5
        }
    }
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var userStore: UserStore
    
    @State private var config = ProfileSetupScreenConfig()
    @State private var alert: NXGenericAlert? = nil
        
//    let horizontalTransition: AnyTransition = .asymmetric(
//        insertion: .move(edge: .trailing),
//        removal: .move(edge: .leading))
    
    var body: some View {
        VStack {
            if config.setupProgress < 4 {
                ProgressIndicator()
            }
            Spacer()
            
            ZStack(alignment: .leading) {
                Spacer(minLength: 290)
                
                switch config.setupProgress {
                case 0:
                    GenderTab()
                case 1:
                    DateOfBirthTab()
                case 2:
                    HeightTab()
                case 3:
                    WeightTab()
                case 4:
                    AlmostThereTab()
                case 5:
                    GoalTab()
                default:
                    ActivityTab()
                }
            }
            
            Spacer()
            if config.setupProgress != 4 {
                ActionButton()
            }
        }
        .showAlert(alert: $alert)
        .loadingView(isLoading: config.isLoading)
    }
}

// MARK: - VIEWS -
extension ProfileSetupScreen {
    
    @ViewBuilder
    private func ProgressIndicator() -> some View {
        HStack(spacing: 6.0) {
            ForEach(0..<4) { index in
                Capsule()
                    .fill(index == config.setupProgress ? .nxAccent : .primary)
                    .frame(width: index == config.setupProgress ? 32.0 : 4.0, height: 4.0)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32.0)
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func GenderTab() -> some View {
        //        ZStack(alignment: .trailing) {
        //            Image(.manExercise1)
        //                .resizable()
        //                .aspectRatio(contentMode: .fit)
        //                .opacity(0.6)
        //                .frame(width: 320)
        //                .offset(x: xOffset, y: -120)
        
        HStack {
            VStack(alignment: .leading, spacing: 8.0) {
                Spacer()
                
                AnimatedText("Your gender")
                    .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                    .padding(.bottom, 8.0)
                
                Text("To estimate your body's\nmetabolic rate.")
                    .font(.customFont(font: .ubuntu, weight: .bold, size: .body, relativeTo: .body))
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        NXRadioButton(gender.rawValue, selected: gender == config.selectedGender) {
                            if config.selectedGender != gender {
                                config.selectedGender = gender
                            }
                        }
                    }
                }
                .padding(.vertical, 32.0)
            }
            
            Spacer()
        }
        .padding(32.0)
    }
    //        .onAppear {
    //            withAnimation(.smooth(duration: 1.0)) {
    //                xOffset = 200
    //            }
    //        }
    //    }
    
    @ViewBuilder
    private func DateOfBirthTab() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            
            AnimatedText("Your birthday")
                .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                .padding(.bottom, 8.0)
            
            Text("To help ")
                .font(.customFont(font: .ubuntu, weight: .bold))
                .foregroundStyle(.secondary)
            +
            Text("personalize ")
                .font(.customFont(font: .ubuntu, weight: .bold, size: .body, relativeTo: .body))
                .foregroundStyle(.nxAccent)
            +
            Text("NUTREX\nfor you")
                .font(.customFont(font: .ubuntu, weight: .bold))
                .foregroundStyle(.secondary)
            
            DatePicker(selection: $config.dateOfBirth, displayedComponents: .date) { }
                .datePickerStyle(.wheel)
                .padding(.vertical)
        }
        .padding(.horizontal, 24.0)
    }
    
    @ViewBuilder
    private func HeightTab() -> some View {
        VStack(alignment: .leading, spacing: 32.0) {
            Spacer()
            
            VStack(alignment: .leading) {
                AnimatedText("Your height")
                    .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                    .padding(.bottom, 8.0)
                
                Text("This helps with the bmi\ncalculation")
                    .font(.customFont(font: .ubuntu, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24.0)
            
            VStack {
                Picker("Measurement Unit", selection: $config.metricType) {
                    ForEach(MetricType.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                            .tag(unit)
                            .foregroundColor(config.metricType == unit ? .black : .white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200.0)
                .padding(.bottom)
                
                HStack(alignment: .lastTextBaseline, spacing: 4.0) {
                    Text(verbatim: "\(config.heightValue)")
                        .font(.customFont(font: .audiowide, size: .largeTitle))
                        .contentTransition(.numericText(value: config.heightValue))
                        .animation(.snappy, value: config.heightValue)
                    
                    Text(config.metricType.rawValue)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 24.0)
                
                WheelPicker(config: config.heightWheelConfig, value: $config.heightValue)
                    .frame(height: 60)
            }
        }
        .padding(.vertical, 64.0)
    }
    
    @ViewBuilder
    private func WeightTab() -> some View {
        VStack(alignment: .leading, spacing: 32.0) {
            Spacer()
            
            VStack(alignment: .leading) {
                AnimatedText("Your weight")
                    .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                    .padding(.bottom, 8.0)
                
                Text("This helps with the bmi\ncalculation")
                    .font(.customFont(font: .ubuntu, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24.0)
            
            VStack {
                Picker("Measurement Unit", selection: $config.weightType) {
                    ForEach(WeightType.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                            .tag(unit)
                            .foregroundColor(config.weightType == unit ? .black : .white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200.0)
                .padding(.bottom)
                
                HStack(alignment: .lastTextBaseline, spacing: 4.0) {
                    Text(verbatim: "\(config.weightValue)")
                        .font(.customFont(font: .audiowide, size: .largeTitle))
                        .contentTransition(.numericText(value: config.weightValue))
                        .animation(.snappy, value: config.weightValue)
                    
                    Text(config.weightType.rawValue)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 24.0)
                
                WheelPicker(config: config.weightWheelConfig, value: $config.weightValue)
                    .frame(height: 60)
            }
        }
        .padding(.vertical, 64.0)
    }
    
    @ViewBuilder
    private func AlmostThereTab() -> some View {
        AnimatedText("Almost there", animationDuration: 1.0, delayBetweenWords: 0.5)
            .font(.customFont(font: .audiowide, size: .title, relativeTo: .title))
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    config.setupProgress += 1
                }
            }
    }
    
    @ViewBuilder
    private func GoalTab() -> some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 8.0) {
                Spacer()
                
                AnimatedText("Your goal")
                    .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                    .padding(.bottom, 8.0)
                
                Text("This helps on calculations.")
                    .font(.customFont(font: .ubuntu, weight: .bold, size: .body, relativeTo: .body))
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    ForEach(Goal.allCases, id: \.self) { goal in
                        NXRadioButton(goal.rawValue, selected: goal == config.selectedGoal) {
                            if config.selectedGoal != goal {
                                config.selectedGoal = goal
                            }
                        }
                    }
                }
                .padding(.vertical, 32.0)
            }
            
            Spacer()
        }
        .padding(32.0)
    }
    
    @ViewBuilder
    private func ActivityTab() -> some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 8.0) {
                Spacer()
                
                AnimatedText("Your activity level")
                    .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                    .padding(.bottom, 8.0)
                
                Text("This helps on calculations.")
                    .font(.customFont(font: .ubuntu, weight: .bold, size: .body, relativeTo: .body))
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    ForEach(ActivityLevel.allCases, id: \.self) { activity in
                        NXRadioButton(activity.rawValue, selected: activity == config.activityLevel) {
                            if config.activityLevel != activity {
                                config.activityLevel = activity
                            }
                        }
                    }
                }
                .padding(.vertical, 32.0)
            }
            
            Spacer()
        }
        .padding(32.0)
    }
    
    @ViewBuilder
    private func ActionButton() -> some View {
        NXButton {
            nextStep()
        } label: {
            HStack {
                Text(config.isProfileComplete ? "Finish" : "NEXT")
                
                if config.isProfileComplete {
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .padding(6.0)
                        .background {
                            Circle()
                                .fill(.white)
                        }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}


// MARK: - ACTIONS -
extension ProfileSetupScreen {
    
    private func nextStep() {
        if config.setupProgress < 6 {
            withAnimation(.spring) {
                config.setupProgress += 1
                config.xOffset = 500
            }
        } else if config.setupProgress == 6 {
            config.isLoading = true
            
            Task {
                do {
                    try await userStore.completeUserProfile(gender: config.selectedGender,
                                                            birthDay: config.dateOfBirth,
                                                            weight: config.weightValue,
                                                            height: config.heightValue,
                                                            goal: config.selectedGoal,
                                                            activity: config.activityLevel,
                                                            bodyType: config.bodyType)
                } catch {
                    alert = .noInternetConnection(onOkPressed: {
                        
                    }, onRetryPressed: {
                        
                    })
                }
                
                config.isLoading = false
            }
            
        }
    }
    
}

#Preview {
    ProfileSetupScreen()
}
