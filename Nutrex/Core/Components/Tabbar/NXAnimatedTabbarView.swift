//
//  NXAnimatedTabbarView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 01/05/2024.
//

import SwiftUI

struct NXAnimatedTabbarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String]// = ["All", "My Meals", "Recents"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20.0) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id: \.0,
                        content: {
                    index, name in
                    AnimatedTabBarItem(currentTab: self.$currentTab,
                               namespace: namespace.self,
                               tabBarItemName: name,
                               tab: index)
                    
                })
            }
        }
        .frame(height: 40.0)
    }
}

struct AnimatedTabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .foregroundStyle(currentTab == tab ? .primary : .secondary)
                if currentTab == tab {
                    Color.primary
                        .frame(height: 4)
                        .clipShape(Capsule())
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.bouncy(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
