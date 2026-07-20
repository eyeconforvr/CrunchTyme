//
//  WeatherMapper.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

// TODO: GET SPECIFIC FORECAST FOR DAY
// TODO: CREATE AN ENUM THAT HAS ALL WEATHER CONDITIONS, USE ENUM TO DO SWITCH CASE FOR ICONS


struct WeatherMapper
{
    
    
    static func map(from : WeatherResponse) -> WeatherModel
    {
        WeatherModel(
            sunrise: from.forecast.forecastday.first?.astro.sunrise ?? "",
            sunset: from.forecast.forecastday.first?.astro.sunset ?? "",
            currentTemp: String(from.current.tempC),
            highTemp: String(from.forecast.forecastday.first?.day.maxtempC ?? 0.0),
            lowTemp: String(from.forecast.forecastday.first?.day.mintempC ?? 0.0),
            icon: createIcon(condition: from.current.condition.text)
        )
    }
    
   private static func createIcon(condition : String) -> String
    {
        
        if condition == "Sunny"
        {
            return "sun.max"
        }
        else if condition == "Cloudy"
        {
            return "cloud.fill"
        }
        else
        {
            return "location"
        }
    }
}
