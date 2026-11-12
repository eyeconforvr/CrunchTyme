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
    private var fetchGeneration = 0

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    var weather: WeatherModel = WeatherModel()
    
    var isLoading = true

    func fetchWeather(city: String) async throws {

        fetchGeneration += 1
        let generation = fetchGeneration
        defer {
            if generation == fetchGeneration { isLoading = false }
        }

        let result = try await weatherRepository.getWeather(for: city)
        try _Concurrency.Task.checkCancellation()
        guard generation == fetchGeneration else { return }
        weather = result

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
            },
            locationName: weather.locationName,
            timeZoneIdentifier: weather.timeZoneIdentifier,
            sunriseDate: weather.sunriseDate,
            sunsetDate: weather.sunsetDate
        )
        WeatherDataStore.save(sharedWeather)

        WidgetCenter.shared.reloadTimelines(ofKind: "CrunchTymeWeatherWidget")
    }

}
