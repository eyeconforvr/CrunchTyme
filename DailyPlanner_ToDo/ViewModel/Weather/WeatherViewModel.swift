//
//  WeatherViewModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    private let weatherService = WeatherService()
    private var cancellable: AnyCancellable?
    @Published var weather: WeatherResponse?
    
//    func fetchWeather(city: String) {
//        cancellable = weatherService.getWeather(for: city)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in }, receiveValue: { weather in
//                self.weather = weather
//            })
    
}
