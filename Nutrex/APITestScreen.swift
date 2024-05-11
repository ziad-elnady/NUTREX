//
//  APITestScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 07/05/2024.
//

import SwiftUI

struct APITestScreen: View {
    @StateObject private var networkManager = NetworkManager()
    
    @State private var query = ""
    
    @State private var error: String? = nil
    @State private var isShowingError: Bool = false
    
    @State private var response: EDMAMResponse? = nil
    @State private var servingSelection: ServingSize? = nil
    
    var body: some View {
        VStack(spacing: 16.0) {
            TextField("search for foods...", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    fetchFood(query: query)
                }
            
            VStack(spacing: 8.0) {
                HStack {
                    Text(response?.hints.first?.food.label ?? "NAN")
                    Spacer()
                    Picker("measure", selection: $servingSelection) {
                        ForEach(response?.hints.first?.measures ?? [], id: \.uri) { measure in
                            HStack {
                                Text(measure.label ?? "nothing")
                                Text(" ~ \(measure.weight)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                
            }
            
            Spacer()
        }
        .preferredColorScheme(.light)
        .padding()
        .alert(error ?? "NAN", isPresented: $isShowingError) {
            Button("OK") { }
        }
    }
    
    private func fetchFood(query: String) {
        networkManager.fetchFoodData(for: query) { result in
            switch result {
            case .success(let success):
                response = success
            case .failure(let failure):
                error = failure.localizedDescription
                isShowingError = true
            }
        }
    }
}

#Preview {
    APITestScreen()
}

class NetworkManager: ObservableObject {
    private let baseURL = "https://api.edamam.com/api/food-database/v2/parser"
    private let appID = "81527bf1"
    private let appKey = "5a6956e18da6497cccc2295d4cd9f710"
    
    func fetchFoodData(for ingredient: String, completion: @escaping (Result<EDMAMResponse, Error>) -> Void) {
        // Construct the full URL with query parameters
        let urlString = "\(baseURL)?app_id=\(appID)&app_key=\(appKey)&ingr=\(ingredient)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(EDMAMResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
}


struct EDMAMResponse: Codable {
    let text: String
    let parsed: [Parsed]
    let hints: [Hint]
    let links: Links

    enum CodingKeys: String, CodingKey {
        case text, parsed, hints
        case links = "_links"
    }
}

// MARK: - Hint
struct Hint: Codable {
    let food: HintFood
    let measures: [Measure]
}

// MARK: - HintFood
struct HintFood: Codable {
    let foodID, label, knownAs: String
    let nutrients: Nutrients
    let category: Category
    let categoryLabel: CategoryLabel
    let image: String?
    let foodContentsLabel, brand: String?
    let servingSizes: [ServingSize]?
    let servingsPerContainer: Int?

    enum CodingKeys: String, CodingKey {
        case foodID = "foodId"
        case label, knownAs, nutrients, category, categoryLabel, image, foodContentsLabel, brand, servingSizes, servingsPerContainer
    }
}

enum Category: String, Codable {
    case genericFoods = "Generic foods"
    case genericMeals = "Generic meals"
    case packagedFoods = "Packaged foods"
}

enum CategoryLabel: String, Codable {
    case food = "food"
    case meal = "meal"
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let enercKcal, procnt, fat, chocdf: Double
    let fibtg: Double?

    enum CodingKeys: String, CodingKey {
        case enercKcal = "ENERC_KCAL"
        case procnt = "PROCNT"
        case fat = "FAT"
        case chocdf = "CHOCDF"
        case fibtg = "FIBTG"
    }
}

// MARK: - ServingSize
struct ServingSize: Codable, Hashable {
    let uri: String
    let label: String
    let quantity: Double
}

// MARK: - Measure
struct Measure: Codable {
    let uri: String
    let label: String?
    let weight: Double
}

// MARK: - Links
struct Links: Codable {
    let next: Next
}

// MARK: - Next
struct Next: Codable {
    let title: String
    let href: String
}

// MARK: - Parsed
struct Parsed: Codable {
    let food: ParsedFood
}

// MARK: - ParsedFood
struct ParsedFood: Codable {
    let foodID, label, knownAs: String
    let nutrients: Nutrients
    let category: Category
    let categoryLabel: CategoryLabel
    let image: String

    enum CodingKeys: String, CodingKey {
        case foodID = "foodId"
        case label, knownAs, nutrients, category, categoryLabel, image
    }
}
