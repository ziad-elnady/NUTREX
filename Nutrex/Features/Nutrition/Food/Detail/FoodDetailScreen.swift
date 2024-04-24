//
//  FoodDetailScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 24/04/2024.
//

import SwiftUI

struct FoodDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            FoodHeaderView()
//            CaloriesSectionView()
//            MacrosSectionView()
            
            Spacer()
        }
        .ignoresSafeArea()
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            HeaderActions()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - VIEWS -
extension FoodDetailScreen {
    
    @ViewBuilder
    private func HeaderActions() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.body)
            }
            .foregroundStyle(.primary)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .fill(Color(.nxCard))
                    
            }
            
            Spacer()
            
            HStack(spacing: 8.0) {
                Button {
                    print("save")
                } label: {
                    Image(systemName: "arrow.down")
                        .font(.body)
                }
                .foregroundStyle(.primary)
                .frame(width: 50, height: 50)
                .background {
                    Circle()
                        .fill(Color(.nxCard))
                        
                }
                
                Button {
                    print("like")
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.body)
                }
                .foregroundStyle(.nxAccent)
                .frame(width: 50, height: 50)
                .background {
                    Circle()
                        .fill(Color(.nxCard))
                        
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func CaloriesSectionView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Calories")
                        .sectionHeaderFontStyle()
                        .foregroundStyle(.secondary)
                    Text("514 kcal")
                        .headerFontStyle()
                }
                
                Spacer()
                
//                VStack {
//                    CircularProgressBar(progress: 0.3,
//                                        progressColor: .nxAccent,
//                                        text: "57%")
//                    .frame(width: 70, height: 70)
//                }
            }
        }
//        .padding(.horizontal, 24)
//        .padding(.vertical)
//        .background {
//            RoundedRectangle(cornerRadius: 20.0)
//                .fill(Color(.nxCard))
//        }
        .padding([.top, .horizontal])
    }
    
    @ViewBuilder
    private func MacrosSectionView() -> some View {
        HStack {
            VStack {
                Text("Protien")
                    .bodyFontStyle()
                    .fontWeight(.semibold)
                
                CircularProgressBar(progress: 0.3,
                                    progressColor: .nxAccent,
                                    text: "57%",
                                    description: "32 g")
                .frame(width: 60, height: 60)
                .hSpacing(.center)
            }
            
            VStack {
                Text("Carbs")
                    .bodyFontStyle()
                    .fontWeight(.semibold)
                
                CircularProgressBar(progress: 0.3,
                                    progressColor: .nxAccent,
                                    text: "23%",
                                    description: "215 g")
                .frame(width: 60, height: 60)
                .hSpacing(.center)
            }
            
            VStack {
                Text("Fat")
                    .bodyFontStyle()
                    .fontWeight(.semibold)
                
                CircularProgressBar(progress: 0.3,
                                    progressColor: .nxAccent,
                                    text: "20%",
                                    description: "9 g")
                .frame(width: 60, height: 60)
                .hSpacing(.center)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color(.nxCard))
        }
        .padding([.top, .horizontal])
    }
}

#Preview {
    FoodDetailScreen()
}
