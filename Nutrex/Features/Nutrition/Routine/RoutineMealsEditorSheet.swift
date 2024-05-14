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
    @State private var isAddNewMealScreenPresented = false
    
    let user: User
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
//                        isShowingNewMealDialog = true
                        isAddNewMealScreenPresented = true
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
                .padding(.top, 24.0)
                Divider()
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
            .environment(\.editMode, .constant(isEditMode ? .active : .inactive))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .background {
                Color(.nxBackground)
                    .ignoresSafeArea()
            }
            
            .navigationDestination(isPresented: $isAddNewMealScreenPresented) {
                CreateNewMealRoutineScreen()
            }
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        Task {
            routineMealStore.removeRotineMeal(at: offsets, user: user)
        }
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        Task {
            routineMealStore.moveRoutineMeal(from: source,
                                             to: destination,
                                             user: user)
        }
    }
}

#Preview {
    RoutineMealsEditorSheet(user: User.empty)
        .environmentObject(RoutineMealStore())
}
