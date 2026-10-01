//
//  WeatherModel.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/17.
//

import Foundation

struct WeatherModel
{
    let sunrise : String
    let sunset : String
    let currentTemp : String
    let highTemp : String
    let lowTemp : String
    let icon : String
    let condition : String
    
    
    init(sunrise: String = "", sunset: String  = "" , currentTemp: String  = "" ,highTemp: String = " ", lowTemp: String = "", icon: String  = "", condition: String  = "") {
        self.sunrise = sunrise
        self.sunset = sunset
        self.currentTemp = currentTemp+"°C"
        self.highTemp = highTemp+"°C"
        self.lowTemp = lowTemp+"°C"
        self.icon = icon
        self.condition = condition
    }
    
}
