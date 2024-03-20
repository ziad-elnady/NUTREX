//
//  HealthCalculator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 21/03/2024.
//

import Foundation

class HealthCalculator {
    static let shared = HealthCalculator()

    func calculateBMI(user: User) -> Double {
        let heightInMeters = user.height / 100.0
        return user.weight / (heightInMeters * heightInMeters)
    }

    func calculateBMR(user: User) -> Double {
        var bmr: Double = 0.0

        switch user.wrappedGender {
        case Gender.male.rawValue:
            bmr = 10 * user.weight + 6.25 * user.height - 5 * Double(user.age) + 5
        case Gender.female.rawValue:
            bmr = 10 * user.weight + 6.25 * user.height - 5 * Double(user.age) - 161
        default:
            bmr = 0.0
        }

        return bmr
    }

    func calculateTDEE(user: User) -> Double {
        let activityMultiplier: Double

        switch user.activityLevel {
        case ActivityLevel.sedentary.rawValue:
            activityMultiplier = 1.2
        case ActivityLevel.lightlyActive.rawValue:
            activityMultiplier = 1.375
        case ActivityLevel.moderatelyActive.rawValue:
            activityMultiplier = 1.55
        case ActivityLevel.veryActive.rawValue:
            activityMultiplier = 1.725
        default:
            activityMultiplier = 1.2
        }

        return calculateBMR(user: user) * activityMultiplier
    }

    func calculateCaloricGoal(user: User) -> Double {
        var caloricGoal: Double

        switch user.wrappedGoal {
        case  Goal.maintain.rawValue:
            caloricGoal = calculateTDEE(user: user)
        case Goal.weightLoss.rawValue:
            caloricGoal = calculateTDEE(user: user) * 0.8
        case Goal.weightGain.rawValue:
            caloricGoal = calculateTDEE(user: user) * 1.2
        default:
            caloricGoal = calculateTDEE(user: user)
        }

        return caloricGoal
    }

    func calculateMacronutrientPercentages(user: User) -> (protein: Double, carbohydrates: Double, fat: Double) {
        let proteinPercentage: Double
        let carbohydratesPercentage: Double
        let fatPercentage: Double

        switch user.wrappedGoal {
        case Goal.maintain.rawValue:
            proteinPercentage = 20.0
            carbohydratesPercentage = 50.0
            fatPercentage = 30.0
        case Goal.weightLoss.rawValue:
            proteinPercentage = 25.0
            carbohydratesPercentage = 45.0
            fatPercentage = 30.0
        case Goal.weightGain.rawValue:
            proteinPercentage = 30.0
            carbohydratesPercentage = 40.0
            fatPercentage = 30.0
        default:
            proteinPercentage = 20.0
            carbohydratesPercentage = 50.0
            fatPercentage = 30.0
        }

        let protein = (proteinPercentage / 100.0) * calculateCaloricGoal(user: user)
        let carbohydrates = (carbohydratesPercentage / 100.0) * calculateCaloricGoal(user: user)
        let fat = (fatPercentage / 100.0) * calculateCaloricGoal(user: user)

        return (protein, carbohydrates, fat)
    }
}
