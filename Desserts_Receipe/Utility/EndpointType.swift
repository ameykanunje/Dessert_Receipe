//
//  EndpointType.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import Foundation

protocol EndPointType{
    var path : String{ get }
    var baseURL : String { get }
    var url : URL? { get }
}

enum EndPointItems {
    case Desserts //https://themealdb.com/api/json/v1/1/filter.php?c=Dessert
    case DessertsDetails(mealID : String) //https://themealdb.com/api/json/v1/1/lookup.php?i=53049
}

extension EndPointItems : EndPointType{

    var path: String {
        switch self {
        case .Desserts:
            return "filter.php?c=Dessert"
        case .DessertsDetails(let mealID):
            return "lookup.php?i=\(mealID)"
        }
    }
    
    var baseURL: String {
        return "https://themealdb.com/api/json/v1/1/"
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
}
