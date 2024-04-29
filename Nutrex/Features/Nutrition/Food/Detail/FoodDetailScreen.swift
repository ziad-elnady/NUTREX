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
    
    @ObservedObject var food: Food
    
    @State private var isShowingUnitSelectionSheet = false
    
    @State private var nutritionFacts = (calories: 0.0, protein: 0.0, carbs: 0.0, fat: 0.0)
    @State private var macrosPercentages = (proteinPercentage: 0.0, carbPercentage: 0.0, fatPercentage: 0.0)
    
    struct MacroSet: Identifiable {
        let id = UUID()
        
        let name: String
        let color: Color
        
        static let protein = MacroSet(name: "protein", color: .nxAccent)
        static let carbs = MacroSet(name: "carbs", color: .nxAccent.opacity(0.5))
        static let fats = MacroSet(name: "fats", color: .nxAccent.opacity(0.25))
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
            SubNutritionData(name: "animal - based", value: 6.7),
            SubNutritionData(name: "plant - based", value: 0.0)
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
    
    var body: some View {
        let _ = Self._printChanges()
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0.0, pinnedViews: [.sectionHeaders]) {
                Section {
                    FoodNameSection()
                        .padding(.top)
                    
                    NXSectionView(header: "serving") {
                        ServingSection()
                    }
                        .padding(.top)
                    
                    NXSectionView(header: "macros") {
                        MacrosChartView()
                    }
                        .padding(.top)
                    
                    NXSectionView(header: "percent of daily goals") {
                        MacrosView()
                    }
                        .padding(.top)
                    
                    NXSectionView(header: "nutritions") {
                        DetailedNutritionsView()
                    }
                        .padding(.top)
                } header: {
                    HeaderActions()
                }
            }
            .hSpacing(.leading)
        }
        .padding(.horizontal)
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowingUnitSelectionSheet) {
            UnitSelectionSheetView(selectedUnit: $food.unit, units: food.measurmentUnitsList)
                .presentationDetents([.height(400.0), .medium])
                .presentationDragIndicator(.hidden)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            nutritionFacts = food.calculatedNutritionalInfo
            macrosPercentages = food.calculateMacroPercentages()
        }
        .onChange(of: food.serving) { _, newValue in
            nutritionFacts = food.calculatedNutritionalInfo
            macrosPercentages = food.calculateMacroPercentages()
        }
        .onChange(of: food.unit) { _, newValue in
            nutritionFacts = food.calculatedNutritionalInfo
            macrosPercentages = food.calculateMacroPercentages()
        }
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
                    Text(food.wrappedName)
                        .headlineFontStyle()
                    
                    Image(systemName: "checkerboard.shield")
                        .foregroundStyle(.nxAccent)
                }
                Text("#protien #meal #product")
                    .captionFontStyle()
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(nutritionFacts.calories, specifier: "%.1f") kcal")
                .headlineFontStyle()
        }
        .carded()
        .padding(.top)
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
                    TextField("Enter servings", value: $food.serving, formatter: NumberFormatter()) {
                        if food.serving > 999 {
                            food.serving = 999
                        }
                    }
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .background(.clear)
                    .keyboardType(.numberPad)
                    .frame(maxWidth: 80)
                    .padding(6.0)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(.tertiary, lineWidth: 1.0)
                    }
                    
                }
                
                HStack {
                    Text("unit")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button {
                        isShowingUnitSelectionSheet.toggle()
                    } label: {
                        Text(food.wrappedUnitName)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: 80.0)
                            .padding(6.0)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(.tertiary, lineWidth: 1.0)
                            }
                    }
                    .foregroundStyle(.quaternary)
                }
            }
            .carded()
        }
    }
    
    @ViewBuilder
    private func MacrosChartView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    ChartMacroView(macroSet: MacroSet.protein, value: nutritionFacts.protein)
                    ChartMacroView(macroSet: MacroSet.carbs, value: nutritionFacts.carbs)
                    ChartMacroView(macroSet: MacroSet.fats, value: nutritionFacts.fat)
                }
                
                Spacer()
                
                    Chart {
                        SectorMark(angle: .value("protein", nutritionFacts.protein))
                        .foregroundStyle(MacroSet.protein.color)
                        
                        SectorMark(angle: .value("carbs", nutritionFacts.carbs))
                        .foregroundStyle(MacroSet.carbs.color)
                        
                        SectorMark(angle: .value("carbs", nutritionFacts.fat))
                        .foregroundStyle(MacroSet.fats.color)
                    }
                    .frame(width: 100)
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
        VStack {
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
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color(.nxCard))
        }
    }
    
    @ViewBuilder
    private func DetailedNutritionsView() -> some View {
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
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8.0)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color(.nxCard), lineWidth: 2)
            }
        }
    }
    
    @ViewBuilder
    private func MacrosView() -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 24.0) {
                MacroView(name: "Protein", value: nutritionFacts.protein, percentage: macrosPercentages.proteinPercentage)
                MacroView(name: "Carbs", value: nutritionFacts.carbs, percentage: macrosPercentages.carbPercentage)
                MacroView(name: "Protein", value: nutritionFacts.fat, percentage: macrosPercentages.fatPercentage)
            }
            
            Text("Represents how much does this food take space in your total diary needs.")
                .captionFontStyle()
                .foregroundStyle(.tertiary)
                .padding(.top, 8.0)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color(.nxCard))
        }
    }
}

// MARK: - VIEWS -
extension FoodDetailScreen {
    
    struct ChartMacroView: View {
        let macroSet: MacroSet
        let value: Double
        
        var body: some View {
            HStack {
                Capsule()
                    .fill(macroSet.color)
                    .frame(width: 5)
                    .padding(.vertical, 3.0)
                
                VStack(alignment: .leading) {
                    Text(macroSet.name)
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                    
                    Text("\(value, specifier: "%.1f") gm ~ NaN%")
                        .captionFontStyle()
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    struct MacroView: View {
        let name: String
        let value: Double
        let percentage: Double
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6.0) {
                Text(name)
                    .captionFontStyle()
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                HStack(alignment: .bottom) {
                    
                    
                    Text("\(value, specifier: "%.1f") g")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("\(percentage.formatCalories())%")
                        .captionFontStyle()
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
                
                
                
                ProgressView(value: percentage, total: 100)
                    .tint(.nxAccent)
            }
        }
    }
    
    struct UnitSelectionSheetView: View {
        @Environment(\.dismiss) private var dismiss
        
        @Binding var selectedUnit: Int16
        
        let units: [MeasurementUnit]
        
        var body: some View {
            ScrollView {
                VStack {
                    HStack {
                        Text("Select Unit")
                            .font(.title2.bold())
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.nxAccent)
                    }
                    .padding([.top, .leading, .trailing])
                    
                    Divider()
                    
                    ForEach(units.indices, id: \.self) { index in
                        HStack {
                            Text(units[index].wrappedUnitName).tag(units[index].wrappedUnitName)
                                .font(.title3)
                            Spacer()
                            Image(systemName: selectedUnit == index ? "record.circle" : "circle")
                                .font(.callout)
                                .foregroundStyle(selectedUnit == index ? .nxAccent : .secondary)
                        }
                        .padding()
                        .background(selectedUnit == index ? .gray.opacity(0.08) : .clear)
                        .onTapGesture {
                            dismiss()
                            selectedUnit = Int16(index)
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    FoodDetailScreen(food: Food.example)
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


struct NXSectionView<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading)
            
            content
        }
    }
}
