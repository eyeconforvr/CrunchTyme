//
//  WeatherViewModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import Combine
import Foundation
import WidgetKit

@Observable
class WeatherViewModel {

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    var weather: WeatherModel = WeatherModel()

    func fetchWeather(city: String) async throws {

        weather = try await weatherRepository.getWeather(for: city)

        let sharedWeather = SharedWeatherData(
            currentTemp: weather.currentTemp,
            highTemp: weather.highTemp,
            lowTemp: weather.lowTemp,
            condition: weather.condition,
            icon: weather.icon,
            sunrise: weather.sunrise,
            sunset: weather.sunset,
            dailyForecast: weather.dailyForecast.map { forecast in
                SharedDailyForecast(
                    day: forecast.day,
                    highTemp: forecast.highTemp,
                    lowTemp: forecast.lowTemp,
                    icon: forecast.icon,
                    condition: forecast.condition
                )
            }
        )
        WeatherDataStore.save(sharedWeather)
        
        WidgetCenter.shared.reloadTimelines( ofKind: "CrunchTymeWeatherWidget" )
    }

}
