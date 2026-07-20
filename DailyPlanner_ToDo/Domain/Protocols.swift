//
//  Protocols.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation


protocol WeatherServiceProtocol {
    func getWeather(for city: String) async throws -> WeatherResponse
}

protocol WeatherRepositoryProtocol
{
    func getWeather(for city: String) async throws -> WeatherModel
}

//protocol Greeter {
//    func greet(name: String) -> String
//}
//
//class UserGreeter: Greeter {
//    
//    func greet(name: String) -> String {
//        "Hello, \(name)!"
//    }
//}
//
//TestViewModel(greeter: UserGreeter())
//
//
//class TestViewModel {
//    let greeter: Greeter
//    
//    init(greeter: Greeter) {
//        self.greeter = greeter
//    }
//    
//    func greet() {
//        greeter.greet(name: "")
//    }
//}
