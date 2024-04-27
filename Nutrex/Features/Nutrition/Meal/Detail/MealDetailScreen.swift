//
//  MealDetailScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 26/04/2024.
//

import SwiftUI

struct MealDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            MealDetailHeaderView()
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
extension MealDetailScreen {
    
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
    
}

#Preview {
    MealDetailScreen()
}
