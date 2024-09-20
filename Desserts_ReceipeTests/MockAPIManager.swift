//
//  MockAPIManager.swift
//  Desserts_ReceipeTests
//
//  Created by Amey Kanunje on 9/19/24.
//

import XCTest
@testable import Desserts_Receipe

class MockAPIManager: APIManagerProtocol{
    
    var mockDessert: Dessert?
    var mockDessertDetails: DessertDetails?
    var shouldThrowError: Bool = false
    
    func request<T: Decodable>(modelType: T.Type, type: EndPointType) async throws -> T {
        if shouldThrowError{
            throw DataError.invalidResponse
        }
        
        //handler errors for Desserts
        if let dessert = mockDessert, modelType == Dessert.self {
            guard let result = dessert as? T else{
                throw DataError.invalidData
            }
            return result
        }
        
        if let dessertDetails = mockDessertDetails, modelType == DessertDetails.self {
            guard let result = dessertDetails as? T else{
                throw DataError.invalidData
            }
            return result
        }
        
        throw DataError.invalidData
        
    }
}


