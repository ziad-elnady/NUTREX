//
//  ProfileSetupScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import FirebaseAuth
import SwiftUI

fileprivate struct ProfileSetupScreenConfig {
    var setupProgress = 0
    
    var selectedGender: Gender          = .male
    var dateOfBirth: Date               = Date.now.onlyDate
    var activityLevel: ActivityLevel    = .sedentary
}

struct ProfileSetupScreen: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var userStore: UserStore
    
    @State private var xOffset: CGFloat = 500
    @State private var config = ProfileSetupScreenConfig()
    
    let horizontalTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)).animation(.smooth(duration: 2.0))
    
    var body: some View {
        VStack {
            ProgressIndicator()
            Spacer()
            
            ZStack(alignment: .leading) {
                Spacer(minLength: 290)
                
                switch config.setupProgress {
                case 0:
                    GenderTab()
                        .transition(horizontalTransition)
                case 1:
                    DateOfBirthTab()
                        .transition(horizontalTransition)
                case 2:
                    GenderTab()
                        .transition(horizontalTransition)
                default:
                    Text("end...")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Spacer()
            ActionButton()
        }
    }
}

// MARK: - VIEWS -
extension ProfileSetupScreen {
    
    @ViewBuilder
    private func ProgressIndicator() -> some View {
        HStack(spacing: 6.0) {
            ForEach(0..<3) { index in
                Capsule()
                    .fill(index == config.setupProgress ? .nxAccent : .secondary)
                    .frame(width: index == config.setupProgress ? 32.0 : 6.0, height: 6.0)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32.0)
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func GenderTab() -> some View {
        ZStack(alignment: .center) {
            Image(.manExercise1)
                .resizable()
                .scaledToFit()
                .opacity(0.6)
                .frame(width: 630)
                .offset(x: xOffset, y: -120)
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text("Your gender")
                    .font(.customFont(font: .orbitron, weight: .bold, size: .headline, relativeTo: .headline))
                    .padding(.bottom, 8.0)
                
                Text("To estimate your body's")
                    .font(.customFont(font: .ubuntu, weight: .bold, size: .body, relativeTo: .body))
                    .foregroundStyle(.secondary)
                Text("metabolic rate.")
                    .font(.customFont(font: .ubuntu, weight: .bold, size: .body, relativeTo: .body))
                    .foregroundStyle(.nxAccent)
                
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
        }
        .onAppear {
            withAnimation(.smooth(duration: 1.0)) {
                xOffset = 200
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func DateOfBirthTab() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text("Your birthday")
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
            
            DatePicker(selection: $config.dateOfBirth, displayedComponents: .date) {
                
            }
            .datePickerStyle(.wheel)
            .padding(.vertical, 32.0)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func ActionButton() -> some View {
        NXButton {
            nextStep()
        } label: {
            HStack {
                Text("NEXT")
                
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .fontWeight(.heavy)
                    .padding(6.0)
                    .background {
                        Circle()
                            .fill(.white)
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
        if config.setupProgress < 3 {
            withAnimation(.spring) {
                config.setupProgress += 1
                xOffset = 500
            }
        } else {
            withAnimation(.spring) {
                config.setupProgress = 0
            }
        }
    }
    
}

#Preview {
    ProfileSetupScreen()
}
