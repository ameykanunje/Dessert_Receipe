//
//  DessertDetailsViewModel.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import Foundation

class DessertDetailsViewModel: ObservableObject {
    @Published var mealDetails: MealDetails?

    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager.shared) {
            self.apiManager = apiManager
        }

    func fetchDessertDetailsData(mealID: String) async throws{
        //Run the async code in a Task
        do{
            let dessertDetails = try await apiManager.request(modelType: DessertDetails.self, type: EndPointItems.DessertsDetails(mealID: mealID))
            //print("dessertDetails- \(dessertDetails)")
            await MainActor.run {
                mealDetails = dessertDetails.meals.first
            }
        }catch{
//            print("Data Loading Error: \(error.localizedDescription)")
            throw error
            
        }
    }

    func getIngredients() -> [(String, String)] {
        return mealDetails?.ingredientsWithMeasures ?? []
    }

}
