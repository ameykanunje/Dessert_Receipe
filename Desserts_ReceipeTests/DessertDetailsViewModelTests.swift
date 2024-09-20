//
//  DessertDetailsViewModelTests.swift
//  Desserts_ReceipeTests
//
//  Created by Amey Kanunje on 9/19/24.
//

import XCTest
@testable import Desserts_Receipe

final class DessertDetailsViewModelTests: XCTestCase {
    
    var viewModel: DessertDetailsViewModel!
    var mockAPIManager: MockAPIManager!
    
    override func setUp(){
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = DessertDetailsViewModel(apiManager: mockAPIManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        super.tearDown()
    }
    
    
    func test_decodeMealDetails_onSuccess() async {
        // given
        let jsonData = """
        {
            "idMeal": "12345",
            "strMeal": "Chocolate Cake",
            "strInstructions": "Mix and bake",
            "strMealThumb": "https://example.com/cake.jpg",
            "strIngredient1": "Sugar",
            "strIngredient2": "",
            "strMeasure1": "1 cup",
            "strMeasure2": ""
        }
        """.data(using: .utf8)!
        
        // when
        let mealDetails = try! JSONDecoder().decode(MealDetails.self, from: jsonData)
        
        // then
        XCTAssertNotNil(mealDetails, "Meal Details should not be nil")
        XCTAssertEqual(mealDetails.mealId, "12345", "Meal ID should match")
        XCTAssertEqual(mealDetails.mealName, "Chocolate Cake", "Meal Name should match")
    }

    
    func test_fetchDessertDetailsJson_onSuccess() async{
        // given
        let jsonData = """
        {
            "idMeal": "53912",
            "strMeal": "Chocolate Cake",
            "strInstructions": "Mix and bake",
            "strMealThumb": "https://example.com/cake.jpg",
            "strIngredient1": "Sugar",
            "strIngredient2": "",
            "strMeasure1": "1 cup",
            "strMeasure2": ""
        }
        """.data(using: .utf8)!
        
        let decodedMealDetails = try! JSONDecoder().decode(MealDetails.self, from: jsonData)
        
        let mockDessertDetails = DessertDetails(meals: [decodedMealDetails])
        
        mockAPIManager.mockDessertDetails = mockDessertDetails
        
        //when
        do {
            try await viewModel.fetchDessertDetailsData(mealID: "53912")
        } catch {
            XCTFail("Fetching dessert details should not fail: \(error)")
        }
        
        // Then: Verify that the ViewModel has been updated with the correct data
            XCTAssertNotNil(viewModel.mealDetails, "Meal Details should not be nil")
            XCTAssertEqual(viewModel.mealDetails?.mealId, "53912", "Meal ID should match the mock data")
            XCTAssertEqual(viewModel.mealDetails?.mealName, "Chocolate Cake", "Meal Name should match the mock data")
            XCTAssertEqual(viewModel.mealDetails?.mealInstructions, "Mix and bake", "Instructions should match the mock data")
            XCTAssertEqual(viewModel.mealDetails?.mealImage, "https://example.com/cake.jpg", "Image URL should match the mock data")
            
            let ingredients = viewModel.mealDetails?.ingredientsWithMeasures ?? []
            XCTAssertEqual(ingredients.count, 1, "Only non-empty ingredients should be included")
            XCTAssertEqual(ingredients[0].0, "Sugar", "Ingredient should match")
            XCTAssertEqual(ingredients[0].1, "1 cup", "Measure should match")

    }
    
    func test_fetchDessertDetails_isEmpty() async{
        // Given
        mockAPIManager.mockDessertDetails = DessertDetails(meals: [])
        
        // When
        do {
            try await viewModel.fetchDessertDetailsData(mealID: "12345")
        } catch  {
            XCTFail("Fetching Data Should not fail")
        }
        
        // Then
        XCTAssertNil(viewModel.mealDetails,"Nothing is passed so it should be empty")
        
    }
    
    func test_fetchDessertDetails_invalidData() async {
        // Given
        mockAPIManager.mockDessertDetails = nil
        
        //When
        do {
            try await viewModel.fetchDessertDetailsData(mealID: "12356")
            XCTFail("Fetching Should Fail For Invalid Data")
        } catch {
            //Then
            XCTAssertNil(viewModel.mealDetails, "MealDetails should be nil when fetching invalid data")
        }
        
    }
    
    func test_fetchDessertDetails_missingIngredients() async {
        // Given
        let jsonData = """
        {
            "idMeal": "12345",
            "strMeal": "Chocolate Cake",
            "strInstructions": "Mix and bake",
            "strMealThumb": "https://example.com/cake.jpg",
            "strIngredient1": "Sugar",
            "strIngredient2": "",
            "strMeasure1": "1 cup",
            "strMeasure2": ""
        }
        """.data(using: .utf8)!
        
        // When
        let mealDetails = try! JSONDecoder().decode(MealDetails.self, from: jsonData)
        
        // Then
        let ingredients = mealDetails.ingredientsWithMeasures
        XCTAssertEqual(ingredients.count, 1, "Ingredients count should filter out empty ingredients and measures")
        XCTAssertEqual(ingredients[0].0, "Sugar", "First ingredient should match")
        XCTAssertEqual(ingredients[0].1, "1 cup", "First measure should match")
    }

}
