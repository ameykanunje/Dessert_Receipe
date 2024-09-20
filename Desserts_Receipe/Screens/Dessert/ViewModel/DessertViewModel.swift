//
//  DessertViewModel.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import Foundation

class DessertViewModel: ObservableObject{
    
    @Published var meals : [Meals] = []
    
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func fetchDessertData() async throws{
        do{
            let dessertsData = try await apiManager.request(modelType: Dessert.self, type: EndPointItems.Desserts)
            await MainActor.run {
                self.meals = dessertsData.meals
            }
        }catch{
            throw error
        }
    }

}
