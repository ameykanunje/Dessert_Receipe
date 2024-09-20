//
//  DessertDetailsView.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import SwiftUI

struct DessertDetailsView: View {
    @StateObject private var dessertDetailsViewModel: DessertDetailsViewModel
    let mealID: String
    
    init(mealID: String) {
        self.mealID = mealID
        _dessertDetailsViewModel = StateObject(wrappedValue: DessertDetailsViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if dessertDetailsViewModel.mealDetails == nil{
                        ProgressView("Loading...")
                    } else{
                        if let mealDetails = dessertDetailsViewModel.mealDetails {
                            // Dessert Name
                            Text(mealDetails.mealName)
                                .font(.title)
                            
                            // Image
                            if let imageURL = URL(string: mealDetails.mealImage) {
                                AsyncImage(url: imageURL) { image in
                                    image.resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                            
                            // Instructions
                            Text("Instructions:")
                                .font(.system(size: 22, weight: .bold))
                            Text(mealDetails.mealInstructions)
                                .font(.body)
                            
                            // Ingredients
                            Text("Ingredients:")
                                .font(.system(size: 22, weight: .bold))
                            ForEach(dessertDetailsViewModel.getIngredients().indices, id: \.self) { index in
                                let (ingredient, measure) = dessertDetailsViewModel.getIngredients()[index]
                                if !ingredient.isEmpty, !measure.isEmpty {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(ingredient) : \(measure)")
                                            .font(.body)
                                    }
                                }
                            }
                        } else {
                            Text("No details available")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dessert Details")
            .onAppear {
                Task{
                    do{
                        try await dessertDetailsViewModel.fetchDessertDetailsData(mealID: mealID)
                    }catch{
                        print("Failed to fetch dessert details: \(error.localizedDescription)")
                    }
                    
                }
                
            }
        }
    }
}
    
#if DEBUG
    struct DessertDetailsView_Previews: PreviewProvider {
        static var previews: some View {
            DessertDetailsView(mealID: "53049")
        }
    }
#endif
