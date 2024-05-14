//
//  CreateNewMealRoutineScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/05/2024.
//

import SwiftUI

struct CreateNewMealRoutineScreen: View {
    //    @Environment(\.dismiss) private var dismiss
    private struct IconCategory: Identifiable {
        let id = UUID()
        let name: String
        let iconItems: [IconItem]
        
        static let categories: [IconCategory] = [
            IconCategory(name: "fruits",
                         iconItems: [
                            IconItem(name: "Orange", iconName: "food-1"),
                            IconItem(name: "Strewberry", iconName: "food-2"),
                            IconItem(name: "Orange", iconName: "food-3"),
                            IconItem(name: "Orange", iconName: "food-4"),
                            IconItem(name: "Orange", iconName: "food-5"),
                            IconItem(name: "Orange", iconName: "food-6"),
                            IconItem(name: "Orange", iconName: "food-7"),
                            IconItem(name: "Orange", iconName: "food-8"),
                            IconItem(name: "Orange", iconName: "food-9"),
                            IconItem(name: "Orange", iconName: "food-10"),
                            IconItem(name: "Orange", iconName: "food-11")
                         ]),
            
            IconCategory(name: "meals",
                         iconItems: [
                            IconItem(name: "Orange", iconName: "meal-1"),
                            IconItem(name: "Orange", iconName: "meal-2"),
                            IconItem(name: "Orange", iconName: "meal-3"),
                            IconItem(name: "Orange", iconName: "meal-4"),
                            IconItem(name: "Orange", iconName: "meal-5"),
                            IconItem(name: "Orange", iconName: "meal-6"),
                            IconItem(name: "Orange", iconName: "meal-7"),
                            IconItem(name: "Orange", iconName: "meal-8"),
                            IconItem(name: "Orange", iconName: "meal-9"),
                         ]),
        ]
    }
    
    private struct IconItem: Identifiable {
        let id = UUID()
        let name: String
        let iconName: String
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var routineMealStore: RoutineMealStore
    
    @State private var mealName = ""
    @State private var mealTime = Date()
    @State private var chosenIconName = ""
    
    private var isFormValid: Bool {
        mealName.isEmpty && chosenIconName.isEmpty
    }
    
    private let rows: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("meal name", text: $mealName)
                    .carded()
                
                VStack {
                    HStack {
                        Text("reminder (optional)")
                            .bodyFontStyle()
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        DatePicker("", selection: $mealTime, displayedComponents: .hourAndMinute)
                    }
                    
                    Text("you can set a reminder that notifies you when this meal's time comes")
                        .captionFontStyle()
                        .foregroundStyle(.tertiary)
                }
                .carded()
                .padding(.top, 8.0)
                
                VStack(alignment: .leading) {
                    Text("choose an icon")
                        .bodyFontStyle()
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    ForEach(IconCategory.categories, id: \.name) { category in
                        CategoryView(selectedIcon: $chosenIconName, category: category)
                    }
                }
                .padding(.top)
                .hSpacing(.leading)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
        .navigationTitle("Create new routine")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem {
                Button {
                    routineMealStore
                        .createNewRoutineMeal(name: mealName,
                                              user: userStore.currentUser)
                } label: {
                    Text("Save")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                }
                .disabled(isFormValid)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - VIEWS -
extension CreateNewMealRoutineScreen {
    
    private struct CategoryView: View {
        @Binding var selectedIcon: String
        
        let category: IconCategory
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(category.name)
                    .bodyFontStyle()
                    .foregroundStyle(.tertiary)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(category.iconItems) { item in
                        Image(item.iconName)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.black)
                            .carded()
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedIcon = item.iconName
                            }
                            .overlay {
                                Circle()
                                    .stroke(selectedIcon == item.iconName ? .nxAccent : .clear, lineWidth: 2.0)
                            }
                    }
                }
            }
            .padding(.top, 8.0)
        }
    }
    
}

#Preview {
    NavigationStack {
        CreateNewMealRoutineScreen()
            .environmentObject(UserStore())
            .environmentObject(RoutineMealStore())
    }
}
