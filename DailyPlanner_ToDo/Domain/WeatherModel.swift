//
//  WeatherModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

struct DailyForecastModel {

    let day: String
    let highTemp: String
    let lowTemp: String
    let icon: String
    let condition: String
}

struct HourlyForecastModel {

    let time: String
    let highTemp: String
    let lowTemp: String
    let icon: String
    let condition: String
}

struct WeatherModel {

    let sunrise: String
    let sunset: String
    let currentTemp: String
    let highTemp: String
    let lowTemp: String
    let icon: String
    let condition: String
    let isDay: Bool
    let dailyForecast: [DailyForecastModel]
    let hourlyForecast: [HourlyForecastModel]

    init(
        sunrise: String = "",
        sunset: String = "",
        currentTemp: String = "",
        highTemp: String = " ",
        lowTemp: String = "",
        icon: String = "",
        condition: String = "",
        isDay: Bool = true,
        dailyForecast: [DailyForecastModel] = [],
        hourlyForecast: [HourlyForecastModel] = []
    ) {

        self.sunrise = sunrise
        self.sunset = sunset
        self.currentTemp = currentTemp + "°C"
        self.highTemp = highTemp + "°C"
        self.lowTemp = lowTemp + "°C"
        self.icon = icon
        self.condition = condition
        self.isDay = isDay
        self.dailyForecast = dailyForecast
        self.hourlyForecast = hourlyForecast
    }
}

