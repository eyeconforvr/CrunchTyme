//
//  DailyPlanner_ToDoTests.swift
//  DailyPlanner_ToDoTests
//
//  Created by AJ Mhlanga on 2026/07/24.
//

import XCTest
import Testing
@testable import DailyPlanner_ToDo

final class WeatherXCTests: XCTestCase {
    
    
    private var mockRepository: MockWeatherRepository!
    private var viewModel: WeatherViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockWeatherRepository()
        
    }
    
    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    
    func testFetchWeather() async throws {
        
        let expectedCity = "Sandton"
        
        
        let weather = try await mockRepository.getWeather(for: expectedCity)
        
        
        XCTAssertNotNil(weather)
    }
    
    
    class MockWeatherRepository: WeatherRepositoryProtocol {
        func getWeather(for city: String) async throws -> WeatherModel {
            return WeatherModel()
        }
    }
}



