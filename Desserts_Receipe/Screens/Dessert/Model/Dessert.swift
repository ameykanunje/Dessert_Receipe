//
//  Dessert.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import Foundation

struct Dessert: Codable, Equatable, Hashable {
    let meals: [Meals]
    
    enum CodingKeys: String, CodingKey {
        case meals
    }
}

struct Meals: Codable, Equatable, Hashable {
    let mealName: String
    let mealImage: String
    let mealId: String
    
    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealImage = "strMealThumb"
        case mealId = "idMeal"
    }
}
