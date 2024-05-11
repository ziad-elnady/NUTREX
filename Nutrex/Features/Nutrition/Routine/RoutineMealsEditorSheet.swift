//
//  RoutineMealsEditorSheet.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 11/05/2024.
//

import SwiftUI

struct RoutineMealsEditorSheet: View {
    @EnvironmentObject private var routineMealStore: RoutineMealStore
    
    @State private var isEditMode = true
    @State private var isShowingNewMealDialog = false
    @State private var newMealName = ""
    
    let user: User
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isShowingNewMealDialog = true
                } label: {
                    Text("\(Image(systemName: "plus.circle.fill"))  Add New")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        isEditMode.toggle()
                    }
                } label: {
                    Text(isEditMode ? "Done" : "Edit")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                }
            }
            .hSpacing(.trailing)
            .padding(.horizontal)
            .padding(.vertical, 24.0)
                        
//            VStack(alignment: .leading) {
//                Text("Your existing ones")
//                    .headlineFontStyle()
//
//                Text("It's very flexible editing and adding all your daily routine meals")
//                    .captionFontStyle()
//                    .foregroundStyle(.secondary)
//            }
//            .hSpacing(.leading)
//            .padding([.horizontal, .top])
            
            List {
                ForEach(routineMealStore.routineMeals) { routineMeal in
                    VStack(alignment: .leading) {
                        Text(routineMeal.wrappedName)
                            .bodyFontStyle()
                            .fontWeight(.semibold)
                        
                        Text("no description")
                            .bodyFontStyle()
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: removeItems)
                .onMove(perform: moveItems)
                .listRowSeparator(.hidden)
                .listRowBackground(Color(.nxCard))
            }
        }
        .alert("Add new meal routine", isPresented: $isShowingNewMealDialog) {
            TextField("Enter meal name", text: $newMealName)
            Button("Save") {
                routineMealStore.createNewRoutineMeal(name: newMealName,
                                                      user: user)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will add a new meal routine to your existing ones.")
        }
        .environment(\.editMode, .constant(isEditMode ? .active : .inactive))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        Task {
            routineMealStore.removeRotineMeal(at:)
        }
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        Task {
            routineMealStore.moveRoutineMeal
        }
    }
}

#Preview {
    RoutineMealsEditorSheet(user: User.empty)
        .environmentObject(RoutineMealStore())
}
