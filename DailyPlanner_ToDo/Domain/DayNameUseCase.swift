//
//  DayFilterUseCase.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import Foundation

protocol DayFiltering{
    func abbreviateDay(_ day: String) -> String
}

final class DayNameUseCase : DayFiltering{
    
    func abbreviateDay(_ day: String) -> String {
        
        switch day {
        case "Monday":
            return "Mon"
        case "Tuesday":
            return "Tues"
        case "Wednesday":
            return "Wed"
        case "Thursday":
            return "Thurs"
        case "Friday":
            return "Fri"
        case "Saturday":
            return "Sat"
        case "Sunday":
            return "Sun"
        default:
            return day
        }
    }
}
