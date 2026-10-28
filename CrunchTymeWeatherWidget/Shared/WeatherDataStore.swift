//
//  WeatherDataStore.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import Foundation

struct WeatherDataStore {

    private static let suiteName = "group.com.alfrxdjr.DailyPlanner-ToDo"
    private static let weatherKey = "sharedWeatherData"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName)!
    }

    static func save(_ weather: SharedWeatherData) {
        do {
            let data = try JSONEncoder().encode(weather)
            defaults.set(data, forKey: weatherKey)
        } catch {
            print("Failed to save weather data: \(error)")
        }
    }

    static func load() -> SharedWeatherData? {
        guard let data = defaults.data(forKey: weatherKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(
                SharedWeatherData.self,
                from: data
            )
        } catch {
            print("Failed to load weather data: \(error)")
            return nil
        }
    }
}
