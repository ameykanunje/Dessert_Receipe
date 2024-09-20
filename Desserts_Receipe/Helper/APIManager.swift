//
//  APIManager.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import Foundation


protocol APIManagerProtocol {
    func request<T: Decodable>(
        modelType: T.Type,
        type: EndPointType
    ) async throws -> T
}

enum DataError : Error{
    case invalidURL
    case invalidData
    case invalidResponse
    case network(Error?)
    case networkError(String)
}


class APIManager: APIManagerProtocol{
    
    static let shared = APIManager()
    
    private init(){}
    
    func request<T: Decodable>(
        modelType : T.Type,
        type : EndPointType
    ) async throws -> T{
        
        guard let url = type.url else{
            throw DataError.invalidURL
        }
         
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else{
                throw DataError.invalidResponse
            }
            
            do {
                let decodedData = try JSONDecoder().decode(modelType, from: data)
                return decodedData
            } catch {
                throw DataError.invalidData
            }
            
        }catch{
            throw DataError.network(error)
        }
        
    }
    
}
