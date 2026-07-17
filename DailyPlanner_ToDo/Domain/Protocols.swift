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
