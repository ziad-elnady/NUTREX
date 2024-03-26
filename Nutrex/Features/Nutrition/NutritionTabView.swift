//
//  NutritionTabView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 26/03/2024.
//

import SwiftUI



struct NutritionTabView: View {
    
    enum TabItem: String, CaseIterable {
        case diary
        case meals
        case store
        case profile
        
        var title: String {
            switch self {
            case .diary:
                return "diary"
            case .meals:
                return "meals"
            case .store:
                return "store"
            case .profile:
                return "profile"
            }
        }
        
        var icon: String {
            switch self {
            case .diary:
                return "calendar"
            case .meals:
                return "fork.knife"
            case .store:
                return "storefront"
            case .profile:
                return "person.fill"
            }
        }
    }

    struct AnimatedTab: Identifiable {
        let id: UUID = .init()
        var tab: TabItem
        var isAnimating: Bool?
    }
    
    @State private var selectedTab: TabItem = .diary
    @State private var allTabs: [AnimatedTab] = TabItem.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
    var body: some View {
        VStack (spacing: 0){
            TabView(selection: $selectedTab) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    getTabView(for: tab)
                        .setUpTab(tab)
                }
            }
            
            NXTabBarView()
        }
    }
    
    @ViewBuilder
    func getTabView(for tab: TabItem) -> some View {
        switch tab {
        case .diary:
            NutritionDiaryScreen()
        case .meals:
            Text("Settings")
        case .store:
            Text("Notifications")
        case .profile:
            ProfileScreen()
        }
    }
    
    @ViewBuilder
    private func NXTabBarView() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4.0) {
                    Image(systemName: tab.icon)
                        .font(.title3)
                        .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.customFont(font: .audiowide, size: .caption2, relativeTo: .caption2))
                        .textScale(.secondary)
                        
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(selectedTab == tab ? Color.primary : Color.gray.opacity(0.5))
                .padding(.vertical)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        selectedTab = tab
                        animatedTab.isAnimating = true
                    } completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                    
                }
            }
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .overlay {
            RoundedRectangle(cornerRadius: 20.0)
                .stroke(.gray.opacity(0.3), lineWidth: 0.5)
        }
        .padding(.horizontal, 24.0)
    }
}

#Preview {
    NutritionTabView()
}


struct ProfileScreen: View {
    @EnvironmentObject private var authStore: AuthenticationStore
    @EnvironmentObject private var userStore: UserStore
    
    @State private var alert: NXGenericAlert? = nil
    
    var body: some View {
        Button("Sign Out") {
            Task {
                do {
                    try await authStore.signOut()
                    userStore.currentUser = User.empty
                } catch {
                    alert = .dataNotFound(onRetryPressed: {
                        
                    })
                }
            }
        }
        .buttonStyle(.bordered)
        .padding()
        .showAlert(alert: $alert)
    }
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: NutritionTabView.TabItem) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
