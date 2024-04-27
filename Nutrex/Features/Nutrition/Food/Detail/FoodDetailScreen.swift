//
//  FoodDetailScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 24/04/2024.
//

import Charts
import SwiftUI

struct FoodDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var serving = ""
    @State private var unit = ""
    
    struct Macro: Identifiable {
        let id = UUID()
        
        let name: String
        let value: Double
        let percentage: Double
        let color: Color
    }
    
    struct NutritionData: Identifiable {
        let id = UUID()
        
        let name: String
        let totalValue: Double
        let subNutritions: [SubNutritionData]
    }
    
    struct SubNutritionData: Identifiable {
        let id = UUID()
        
        let name: String
        let value: Double
    }
    
    let nutritionsDataExample: [NutritionData] = [
        NutritionData(name: "protein", totalValue: 6.7, subNutritions: [
            SubNutritionData(name: "animal", value: 6.7),
            SubNutritionData(name: "plant", value: 0.0)
        ]),
        
        NutritionData(name: "carbohydrates", totalValue: 32.7, subNutritions: [
            SubNutritionData(name: "dietry fiber", value: 22.4),
            SubNutritionData(name: "sugar", value: 7.8),
            SubNutritionData(name: "added sugars", value: 3.4),
        ]),
        
        NutritionData(name: "fats", totalValue: 6.7, subNutritions: [
            SubNutritionData(name: "saturated", value: 6.7),
            SubNutritionData(name: "trans", value: 2.3),
            SubNutritionData(name: "polyunsaturated", value: 3.2),
            SubNutritionData(name: "monounsaturated", value: 5.0)
        ])
    ]
    
    var example: [Macro] {
        return [
            Macro(name: "Protein", value: 6.7, percentage: 35.0, color: .pink),
            Macro(name: "Carbs", value: 4.2, percentage: 25.0, color: .orange),
            Macro(name: "Fats", value: 3.7, percentage: 40.0, color: .yellow)
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0.0) {
                HeaderActions()
                
                FoodNameSection()
                    .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("SERVING")
                        .captionFontStyle()
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    
                    ServingSection()
                }
                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("MACROS")
                        .captionFontStyle()
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    
                    MacrosSec()
                }
                .padding(.top)
                
//                VStack(alignment: .leading) {
//                    Text("MACROS")
//                        .captionFontStyle()
//                        .foregroundStyle(.secondary)
//                        .padding(.leading)
//                    
//                    MacrosSection()
//                }
//                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("NUTRITIONS")
                        .captionFontStyle()
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    
                    ForEach(nutritionsDataExample) { nutrient in
                        VStack(spacing: 0.0) {
                            HStack {
                                Text(nutrient.name)
                                    .bodyFontStyle()
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(nutrient.totalValue.formatCalories())")
                                    .bodyFontStyle()
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6.0)
                            .background {
                                Color(.nxCard)
                            }
                            .roundedCorner(8.0, corners: [.topLeft, .topRight])
                            
                            ForEach(nutrient.subNutritions) { subNutrient in
                                VStack {
                                    HStack {
                                        Text(subNutrient.name)
                                            .bodyFontStyle()
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("\(subNutrient.value.formatCalories())")
                                            .captionFontStyle()
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.secondary)
                                    }
    //                                Divider()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8.0)
    //                        .background(Color(.nxCard))
                        }
//                        .border(width: 2, edges: [.leading, .trailing, .bottom, .top], color: .nxCard)
//                        .roundedCorner(12.0, corners: [.bottomLeft, .bottomRight])
                        .overlay {
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(Color(.nxCard), lineWidth: 2)
                        }
                    }
                }
                .padding(.top)

                Spacer()
            }
            .hSpacing(.leading)
        }
        .padding(.horizontal)
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
        .scrollIndicators(.hidden)
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
                    print("log")
                } label: {
                    Image(systemName: "heart")
                        .font(.body)
                }
                .foregroundStyle(.secondary)
                .frame(width: 50, height: 50)
                .background {
                    Circle()
                        .fill(Color(.nxCard))
                        
                }
                
                Button {
                    print("log")
                } label: {
                    Image(systemName: "bag.fill.badge.plus")
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
    }
    
    @ViewBuilder
    private func FoodNameSection() -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Egg")
                        .headlineFontStyle()
                    
                    Image(systemName: "checkerboard.shield")
                        .foregroundStyle(.nxAccent)
                }
                Text("Protien")
                    .captionFontStyle()
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("67 kcal")
                .headlineFontStyle()
        }
        .carded()
    }
    
    @ViewBuilder
    private func ServingSection() -> some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text("serving")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    TextField("1.0", text: $serving)
                        .frame(maxWidth: 120.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("unit")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    TextField("gram", text: $unit)
                        .frame(maxWidth: 120.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .carded()
        }
    }
    
    @ViewBuilder
    private func MacrosSection() -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Rectangle()
                            .fill(example[0].color)
                            .frame(width: 5, height: 5)
                        
                        Text("protien")
                            .bodyFontStyle()
                            .foregroundStyle(.secondary)
                        
                        Text("6.7 gm ~ 27%")
                            .captionFontStyle()
                            .foregroundStyle(.tertiary)
                    }
                    
                    HStack {
                        Rectangle()
                            .fill(example[1].color)
                            .frame(width: 5, height: 5)
                        
                        Text("carbs")
                            .bodyFontStyle()
                            .foregroundStyle(.secondary)
                        
                        Text("1 gm ~ 5%")
                            .captionFontStyle()
                            .foregroundStyle(.tertiary)
                    }
                    HStack {
                        Rectangle()
                            .fill(example[2].color)
                            .frame(width: 5, height: 5)
                        
                        Text("fats")
                            .bodyFontStyle()
                            .foregroundStyle(.secondary)
                        
                        Text("28 gm ~ 69%")
                            .captionFontStyle()
                            .foregroundStyle(.tertiary)
                    }
                }
                
                Spacer()
                
                HStack {
                    Chart {
                        ForEach(example) { macro in
                            SectorMark(angle: .value("macro", macro.percentage),
//                                       innerRadius: .ratio(0.75),
                                       angularInset: 4.0)
                            .cornerRadius(8.0)
                            .foregroundStyle(macro.color)
                        }
                    }
                    .frame(width: 80, height: 80)
                }
            }
            .carded()
        }
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
    }
    
    @ViewBuilder
    private func MacrosSec() -> some View {
        HStack(spacing: 24.0) {
            ForEach(example) { macro in
                VStack(alignment: .leading, spacing: 6.0) {
                    Text(macro.name)
                        .captionFontStyle()
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    HStack(alignment: .bottom) {
                        
                        
                        Text("\(macro.value.formatted()) g")
                            .captionFontStyle()
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(macro.percentage.formatCalories())%")
                            .captionFontStyle()
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                    
                    ProgressView(value: macro.percentage, total: 100)
                        .tint(.nxAccent)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color(.nxCard))
        }
    }
}

#Preview {
    FoodDetailScreen()
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
