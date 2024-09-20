//
//  DessertsViewModelTests.swift
//  Desserts_ReceipeTests
//
//  Created by Amey Kanunje on 9/19/24.
//

import XCTest
@testable import Desserts_Receipe

final class DessertsViewModelTests: XCTestCase {

    var viewModel: DessertViewModel!
    var mockAPIManager: MockAPIManager!
    
    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = DessertViewModel(apiManager: mockAPIManager)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        super.tearDown()
    }
    
    func test_fetchDessertData_onSuccess() async {
        //Given, Arrange
        let expectedMeal = Meals(mealName: "Cake", mealImage: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", mealId: "53049")
        mockAPIManager.mockDessert = Dessert(meals: [expectedMeal])
        
        //When, Act
        do {
            try await viewModel.fetchDessertData()
        } catch  {
            XCTFail("Fetching Data Should Not Fail")
        }
        
        //Then, Assert
        XCTAssertFalse(viewModel.meals.isEmpty, "Meals should not be empty after sucessful fetch")
        XCTAssertEqual(viewModel.meals.first?.mealName, expectedMeal.mealName, "Meal name should be \(expectedMeal.mealName)")
    }
    
    func test_fetchDessertData_onFailure() async {
        // Given
        mockAPIManager.shouldThrowError = true

        // When
        do {
            try await viewModel.fetchDessertData()
            XCTFail("Fetching data should fail when an error occurs")
        } catch {
            // Assert
            XCTAssertTrue(viewModel.meals.isEmpty, "Meals should be empty on failure")
        }
    }
    
    func test_fetchDessertData_emptyData() async {
        // Given
        mockAPIManager.mockDessert = Dessert(meals: []) // Simulate an empty response
        
        // When
        do {
            try await viewModel.fetchDessertData()
        } catch {
            XCTFail("Fetching data should not fail")
        }
        
        // Then
        XCTAssertTrue(viewModel.meals.isEmpty, "Meals should be empty when API returns no data")
    }
    
    func test_fetchDessertData_invalidData() async {
        //Given
        mockAPIManager.mockDessert = nil
        
        //When
        do {
            try await viewModel.fetchDessertData()
            XCTFail("Fetching Data Should Fail with invalid data")
        } catch  {
            //Assert
            XCTAssert(viewModel.meals.isEmpty, "Meals should remain empty on invalid data")
        }
    }
    
    func test_fetchDessertData_updatesOnMainThread() async{
        //Given
        let expectation = expectation(description: "Meals updated on Main thread")
        let expectedData = Meals(mealName: "Cake", mealImage: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", mealId: "53049")
        mockAPIManager.mockDessert = Dessert(meals: [expectedData])
        
        //When
        do{
            try await viewModel.fetchDessertData()
        }catch{
            XCTFail("Fetching Data Should Not Fail")
        }
        
        //Assert
        
        await MainActor.run {
            XCTAssertTrue(!self.viewModel.meals.isEmpty, "Meals array should be updated on main thread")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
    }
    
}
