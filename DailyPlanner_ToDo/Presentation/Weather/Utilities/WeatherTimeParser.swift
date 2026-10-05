//
//  WeatherTimeParser.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/01.
//

import Foundation

struct WeatherTimeParser {

    static func date(from time: String) -> Date? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let parsedTime = timeFormatter.date(from: time) else {
            return nil
        }

        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: parsedTime)
        let minute = calendar.component(.minute, from: parsedTime)

        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: Date()
        )
    }
    
     static func dayOfWeek(from date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: date) else {
            return ""
        }

        formatter.dateFormat = "EEEE"

        return formatter.string(from: date)
    }
    
    static func formatHour(from time: String) -> String {
        guard let date = parseHour(from: time) else {
            return time
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        return outputFormatter.string(from: date)
    }

     static func parseHour(from time: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        return inputFormatter.date(from: time)
    }
}
