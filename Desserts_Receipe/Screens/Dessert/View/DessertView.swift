//
//  DessertView.swift
//  Desserts_Receipe
//
//  Created by Amey Kanunje on 9/19/24.
//

import SwiftUI

import SwiftUI

struct DessertView: View {
    
    @StateObject var vm = DessertViewModel()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(vm.meals, id: \.self) { meal in
                    HStack{
                        //Image
                        if let imageURL = URL(string: meal.mealImage){
                            AsyncImage(url: imageURL){ image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                
                            }placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        
                        NavigationLink("\(meal.mealName)",destination: DessertDetailsView(mealID: meal.mealId))
                    }
                }
            }.navigationTitle("Dessert Category")
        }
        .onAppear(){
            Task{
                do{
                    try await vm.fetchDessertData()
                }catch{
                    print("Failed to fetch data: \(error.localizedDescription)")
                }
            }
        }
        
    }
}

#Preview {
    DessertView()
}
