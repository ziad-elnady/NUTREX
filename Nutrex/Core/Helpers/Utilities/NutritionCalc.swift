//
//  NutritionCalc.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import Foundation

class NutritionCalculator {
    public static var shared = NutritionCalculator()
    
    //TODO: Refactoring || this function should be called once. then the saved food will has its nutritions saved
    func calculateNutrition(food: Food, unitIndex: Int, servings: Double) -> (calories: Double, protein: Double, carbs: Double, fat: Double) {
                
        let selectedUnit = food.measurmentUnitsList[unitIndex]
        let conversionFactor = selectedUnit.conversionToGrams
        let gramsPerServing = servings * conversionFactor
        
        let calories = gramsPerServing * food.wrappedNutritionalInfo.caloriesPerGram
        let protein = gramsPerServing * food.wrappedNutritionalInfo.proteinPerGram
        let carbs = gramsPerServing * food.wrappedNutritionalInfo.carbsPerGram
        let fat = gramsPerServing * food.wrappedNutritionalInfo.fatPerGram
        
        return (calories, protein, carbs, fat)
    }
}
