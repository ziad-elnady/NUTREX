//
//  ProfileSetupScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

enum MetricType: String, CaseIterable {
    case cm = "cm"
    case inch = "inch"
}

enum WeightType: String, CaseIterable {
    case lb = "lb"
    case kg = "kg"
}



struct ProfileSetupScreen: View {
    
    struct UserProfileSetupConfig {
        
        var selectedGender: Gender          = .male
        var dateOfBirth: Date               =  Date.createDate(day: 1, month: 1, year: 1999)?.onlyDate ?? Date.now.onlyDate
        var bodyType: BodyType              = .ectomorph
        var selectedGoal: Goal              = .maintain
        var activityLevel: ActivityLevel    = .sedentary
                
        var metricType: MetricType          = .cm
        var weightType: WeightType          = .kg
        
        var heightValue: CGFloat = 170
        var weightValue: CGFloat = 70
    }
    
    struct ProfileSetupScreenConfig {
        var setupProgress   = 0
        var isTextShown     = false
        var isLoading       = false
        
        var heightWheelConfig: WheelPicker.Config = .init(count: 250, startValue: 170, multiplier: 1)
        var weightWheelConfig: WheelPicker.Config = .init(count: 180, startValue: 70, multiplier: 1)
        
        var xOffset: CGFloat = 500
        
        var isProfileComplete: Bool {
            setupProgress == 6
        }
    }
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var userStore: UserStore
    
    @State private var screenConfig     = ProfileSetupScreenConfig()
    @State private var userDataConfig   = UserProfileSetupConfig()
    @State private var alert: NXGenericAlert? = nil
        
    let titleTransition: AnyTransition = .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        .combined(with: .opacity)
    
    let descTransition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        .combined(with: .opacity)
    
    let contentTransition: AnyTransition = .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top))
        .combined(with: .opacity)
        .combined(with: .scale(scale: 2, anchor: .bottom))
    
    private let titles: [String] = ["Your gender", "Your Weight", "Your Age"]
    private let descriptions: [String] = [
        "To estimate your body's\nmetabolic rate",
        "Second tab descripition for the user",
        "Last but not least"
    ]
    
    var body: some View {
        VStack {
            if screenConfig.setupProgress < 4 {
                ProgressIndicator()
            }
            Spacer()
            
            ZStack(alignment: .leading) {
                Spacer(minLength: 290)
                
                switch screenConfig.setupProgress {
                case 0:
                    GenderTab()
                        .transition(contentTransition)
                case 1:
                    DateOfBirthTab()
                        .transition(contentTransition)
                case 2:
                    HeightTab()
                        .transition(contentTransition)
                case 3:
                    WeightTab()
                        .transition(contentTransition)
                case 4:
                    AlmostThereTab()
                        .transition(contentTransition)
                case 5:
                    GoalTab()
                        .transition(contentTransition)
                default:
                    ActivityTab()
                        .transition(contentTransition)
                }
            }
            
            Spacer()
            if screenConfig.setupProgress != 4 {
                ActionButton()
            }
        }
        .showAlert(alert: $alert)
        .loadingView(isLoading: screenConfig.isLoading)
    }
}

// MARK: - VIEWS -
extension ProfileSetupScreen {
    
    @ViewBuilder
    private func ProgressIndicator() -> some View {
        HStack(spacing: 6.0) {
            ForEach(0..<4) { index in
                Capsule()
                    .fill(index == screenConfig.setupProgress ? .nxAccent : .primary)
                    .frame(width: index == screenConfig.setupProgress ? 32.0 : 4.0, height: 4.0)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32.0)
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func TitleAndDescription() -> some View {
        VStack {
            if screenConfig.isTextShown {
                Text(titles[screenConfig.setupProgress])
                    .font(.title.bold())
                    .transition(titleTransition)
                    .animation(.smooth(duration: 0.1, extraBounce: 2.0).delay(0.1), value: screenConfig.isTextShown)
            }
            
            if screenConfig.isTextShown {
                Text(descriptions[screenConfig.setupProgress])
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .transition(descTransition)
                    .animation(.bouncy(duration: 0.2, extraBounce: 3.0), value: screenConfig.isTextShown)
            }
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
                        NXRadioButton(gender.rawValue, selected: gender == userDataConfig.selectedGender) {
                            if userDataConfig.selectedGender != gender {
                                userDataConfig.selectedGender = gender
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
            
            DatePicker(selection: $userDataConfig.dateOfBirth, displayedComponents: .date) { }
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
                Picker("Measurement Unit", selection: $userDataConfig.metricType) {
                    ForEach(MetricType.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                            .tag(unit)
                            .foregroundColor(userDataConfig.metricType == unit ? .black : .white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200.0)
                .padding(.bottom)
                
                HStack(alignment: .lastTextBaseline, spacing: 4.0) {
                    Text(verbatim: "\(userDataConfig.heightValue)")
                        .font(.customFont(font: .audiowide, size: .largeTitle))
                        .contentTransition(.numericText(value: userDataConfig.heightValue))
                        .animation(.snappy, value: userDataConfig.heightValue)
                    
                    Text(userDataConfig.metricType.rawValue)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 24.0)
                
                WheelPicker(config: screenConfig.heightWheelConfig, value: $userDataConfig.heightValue)
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
                Picker("Measurement Unit", selection: $userDataConfig.weightType) {
                    ForEach(WeightType.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                            .tag(unit)
                            .foregroundColor(userDataConfig.weightType == unit ? .black : .white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200.0)
                .padding(.bottom)
                
                HStack(alignment: .lastTextBaseline, spacing: 4.0) {
                    Text(verbatim: "\(userDataConfig.weightValue)")
                        .font(.customFont(font: .audiowide, size: .largeTitle))
                        .contentTransition(.numericText(value: userDataConfig.weightValue))
                        .animation(.snappy, value: userDataConfig.weightValue)
                    
                    Text(userDataConfig.weightType.rawValue)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 24.0)
                
                WheelPicker(config: screenConfig.weightWheelConfig, value: $userDataConfig.weightValue)
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
                    screenConfig.setupProgress += 1
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
                        NXRadioButton(goal.rawValue, selected: goal == userDataConfig.selectedGoal) {
                            if userDataConfig.selectedGoal != goal {
                                userDataConfig.selectedGoal = goal
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
                        NXRadioButton(activity.rawValue, selected: activity == userDataConfig.activityLevel) {
                            if userDataConfig.activityLevel != activity {
                                userDataConfig.activityLevel = activity
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
                Text(screenConfig.isProfileComplete ? "Finish" : "NEXT")
                
                if !screenConfig.isProfileComplete {
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
        if screenConfig.setupProgress < 6 {
            withAnimation(.smooth(duration: 0.8)) {
                screenConfig.setupProgress += 1
                screenConfig.xOffset = 500
            }
        } else if screenConfig.isProfileComplete {
            screenConfig.isLoading = true
            
            Task {
                do {
                    try await userStore.completeUserProfile(config: userDataConfig)
                } catch {
                    alert = .noInternetConnection(onOkPressed: {
                        
                    }, onRetryPressed: {
                        
                    })
                }
                
                screenConfig.isLoading = false
            }
            
        }
    }
    
}

#Preview {
    ProfileSetupScreen()
}
