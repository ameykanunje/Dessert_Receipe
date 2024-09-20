//
//  DessertDetails.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//
import Foundation


struct DessertDetails : Codable{
    var meals : [MealDetails]
}

struct MealDetails: Codable {
    var mealId: String
    var mealName: String
    var mealInstructions: String
    var mealImage: String
    var ingredientsWithMeasures: [(String, String)] = []
    
    enum CodingKeys: String, CodingKey {
        case mealId = "idMeal"
        case mealName = "strMeal"
        case mealInstructions = "strInstructions"
        case mealImage = "strMealThumb"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        mealId = try container.decode(String.self, forKey: .mealId)
        mealName = try container.decode(String.self, forKey: .mealName)
        mealInstructions = try container.decode(String.self, forKey: .mealInstructions)
        mealImage = try container.decode(String.self, forKey: .mealImage)
        
        let additionalContainer = try decoder.container(keyedBy: AnyCodingKey.self)
        
        var ingredientsDict = [Int: String]()
        var measuresDict = [Int: String]()
        
        for key in additionalContainer.allKeys {
            if key.stringValue.starts(with: "strIngredient") {
                if let index = Int(key.stringValue.dropFirst("strIngredient".count)),
                   let ingredient = try additionalContainer.decodeIfPresent(String.self, forKey: key), !ingredient.isEmpty {
                    ingredientsDict[index] = ingredient
                }
            } else if key.stringValue.starts(with: "strMeasure") {
                if let index = Int(key.stringValue.dropFirst("strMeasure".count)),
                   let measure = try additionalContainer.decodeIfPresent(String.self, forKey: key), !measure.isEmpty {
                    measuresDict[index] = measure
                }
            }
        }
        
        let maxIndex = max(ingredientsDict.keys.max() ?? 0, measuresDict.keys.max() ?? 0)

        if maxIndex >= 1 {
            for index in 1...maxIndex {
                if let ingredient = ingredientsDict[index], let measure = measuresDict[index] {
                    ingredientsWithMeasures.append((ingredient, measure))
                }
            }
        } else {
            print("No valid indices to iterate over.")
        }
    }
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
