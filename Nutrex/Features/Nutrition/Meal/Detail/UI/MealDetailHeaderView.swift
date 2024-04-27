//
//  MealDetailHeaderView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 26/04/2024.
//

import SwiftUI

extension MealDetailScreen {
    
    
    struct MealDetailHeaderView: View {
        var body: some View {
            Rectangle()
                .opacity(0.0)
                .overlay {
                    Image("meal-1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        Text("Meat | Heigh Protien")
                            .bodyFontStyle()
                        
                        HStack {
                            Text("Chicken, Conoe")
                                .headerFontStyle()
                            Image(systemName: "checkmark.shield.fill")
                                .sectionHeaderFontStyle()
                                .foregroundStyle(.nxAccent)
                        }
                    }
                    .padding()
                    .hSpacing(.leading)
                    .fadingBackground()
                }
                .stetchyHeader()
        }
    }
    
    
}

#Preview {
    MealDetailScreen()
}

struct StetchyHeaderModifier: ViewModifier {
    var startingHeight: CGFloat = 300
    var coordinateSpace: CoordinateSpace = .global
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width, height: stretchedHeight(geometry))
                .clipped()
                .offset(y: stretchedOffset(geometry))
        }
        .frame(height: startingHeight)
    }
    
    private func yOffset(_ geo: GeometryProxy) -> CGFloat {
        geo.frame(in: coordinateSpace).minY
    }
    
    private func stretchedHeight(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > 0 ? (startingHeight + offset) : startingHeight
    }
    
    private func stretchedOffset(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > 0 ? -offset : 0
    }
}

enum FadeDirection {
    case toTop
    case toBottom
    case toLeading
    case toTrailing
}

extension View {
    func fadingBackground(_ direction: FadeDirection = .toTop, stop: CGFloat = 0.5) -> some View {
        let gradient = Gradient(colors: [Color.black.opacity(0), Color.black.opacity(1)])
        
        let startPoint: UnitPoint
        let endPoint: UnitPoint
        
        switch direction {
        case .toTop:
            startPoint = .bottom
            endPoint = .top
        case .toBottom:
            startPoint = .top
            endPoint = .bottom
        case .toLeading:
            startPoint = .trailing
            endPoint = .leading
        case .toTrailing:
            startPoint = .leading
            endPoint = .trailing
        }
        
        return self.background(LinearGradient(gradient: gradient, startPoint: endPoint, endPoint: startPoint)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .opacity(stop))
    }
    
    func stetchyHeader(startingHeight: CGFloat = 300.0, coordinateSpace: CoordinateSpace = .global) -> some View {
        self.modifier(StetchyHeaderModifier())
    }
}
