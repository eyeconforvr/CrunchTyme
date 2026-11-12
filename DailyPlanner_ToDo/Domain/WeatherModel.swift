//
//  WeatherModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

/// Provider-independent measurements. Units: °C, %, mm, and km/h.
struct WeatherMetrics {
    var feelsLikeTemperature: Double?
    var humidity: Double?
    var precipitation: Double?
    var windSpeed: Double?
}

struct DailyForecastModel {

    let day: String
    let highTemp: String
    let lowTemp: String
    let icon: String
    let condition: String
}

struct HourlyForecastModel {

    var metrics = WeatherMetrics()

    let time: String
    let highTemp: String
    let lowTemp: String
    let icon: String
    let condition: String
}

struct WeatherModel {

    let metrics: WeatherMetrics
    let locationName: String
    let timeZoneIdentifier: String?
    let sunriseDate: Date?
    let sunsetDate: Date?

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
        hourlyForecast: [HourlyForecastModel] = [],
        metrics: WeatherMetrics = WeatherMetrics(),
        locationName: String = "",
        timeZoneIdentifier: String? = nil,
        sunriseDate: Date? = nil,
        sunsetDate: Date? = nil
    ) {

        self.metrics = metrics
        self.locationName = locationName
        self.timeZoneIdentifier = timeZoneIdentifier
        self.sunriseDate = sunriseDate
        self.sunsetDate = sunsetDate
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

