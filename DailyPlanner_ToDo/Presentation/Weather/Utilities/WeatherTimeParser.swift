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
}
