//
//  SunCycleView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI
import Combine

enum TimeOfDay {
    case morning
    case day
    case evening
    case night
}

enum WeatherAtmosphere {
    case clear
    case cloudy
    case rainy
    case snowy
    case foggy
}

struct SunCycleView: View {

    let sunrise: Date
    let sunset: Date
    let condition: String
    let temperature: String

    @State private var currentTime = Date()

    var body: some View {

        SunArcView(
            dayProgress: dayProgress,
            nightProgress: nightProgress,
            isDaytime: isDaytime,
            glowAmount: glowAmount
        )
        .animation(
            .easeInOut(duration: 1.5),
            value: timeOfDay
        )
        .onReceive(
            Timer.publish(
                every: 60,
                on: .main,
                in: .common
            ).autoconnect()
        ) { time in

            withAnimation(.linear(duration: 60)) {
                currentTime = time
            }
        }
    }

    // MARK: - Day / Night

    private var isDaytime: Bool {
        currentTime >= sunrise && currentTime <= sunset
    }

    // MARK: - Day Progress

    private var dayProgress: Double {

        guard isDaytime else {
            return 0
        }

        let totalDaylight = sunset.timeIntervalSince(sunrise)
        let elapsedDaylight = currentTime.timeIntervalSince(sunrise)

        guard totalDaylight > 0 else {
            return 0
        }

        return min(
            max(elapsedDaylight / totalDaylight, 0),
            1
        )
    }

    // MARK: - Night Dates

    private var nightStart: Date {

        if currentTime < sunrise {

            // Previous day's sunset
            return Calendar.current.date(
                byAdding: .day,
                value: -1,
                to: sunset
            )!

        } else {

            // Today's sunset
            return sunset
        }
    }

    private var nightEnd: Date {

        if currentTime < sunrise {

            // Today's sunrise
            return sunrise

        } else {

            // Tomorrow's sunrise
            return Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: sunrise
            )!
        }
    }

    // MARK: - Night Progress

    private var nightProgress: Double {

        guard !isDaytime else {
            return 0
        }

        let totalNight = nightEnd.timeIntervalSince(nightStart)
        let elapsedNight = currentTime.timeIntervalSince(nightStart)

        guard totalNight > 0 else {
            return 0
        }

        return min(
            max(elapsedNight / totalNight, 0),
            1
        )
    }

    // MARK: - Time of Day

    private var timeOfDay: TimeOfDay {

        if currentTime < sunrise {

            return .night

        } else if currentTime < sunrise.addingTimeInterval(2 * 60 * 60) {

            return .morning

        } else if currentTime < sunset.addingTimeInterval(-2 * 60 * 60) {

            return .day

        } else if currentTime <= sunset {

            return .evening

        } else {

            return .night
        }
    }

    // MARK: - Background Color

    private var backgroundColor: Color {

        switch atmosphere {

        case .clear:

            switch timeOfDay {

            case .morning:
                return .orange.opacity(0.08)

            case .day:
                return .yellow.opacity(0.05)

            case .evening:
                return .orange.opacity(0.10)

            case .night:
                return .blue.opacity(0.08)
            }

        case .cloudy:
            return .gray.opacity(0.10)

        case .rainy:
            return .blue.opacity(0.12)

        case .snowy:
            return .white.opacity(0.12)

        case .foggy:
            return .gray.opacity(0.14)
        }
    }

    // MARK: - Glow

    private var glowAmount: Double {

        let temperature = Double(
            temperature
                .replacingOccurrences(of: "°C", with: "")
        ) ?? 20

        let temperatureGlow = min(
            max((temperature + 5) / 40, 0),
            1
        )

        let weatherMultiplier: Double

        switch atmosphere {

        case .clear:
            weatherMultiplier = 1.0

        case .cloudy:
            weatherMultiplier = 0.65

        case .rainy:
            weatherMultiplier = 0.35

        case .snowy:
            weatherMultiplier = 0.55

        case .foggy:
            weatherMultiplier = 0.45
        }

        return (0.1 + (temperatureGlow * 0.8)) * weatherMultiplier
    }

    // MARK: - Atmosphere

    private var atmosphere: WeatherAtmosphere {

        let condition = condition.lowercased()

        if condition.contains("rain") ||
            condition.contains("drizzle") ||
            condition.contains("shower") {

            return .rainy
        }

        if condition.contains("snow") ||
            condition.contains("blizzard") {

            return .snowy
        }

        if condition.contains("fog") ||
            condition.contains("mist") {

            return .foggy
        }

        if condition.contains("cloud") ||
            condition.contains("overcast") {

            return .cloudy
        }

        return .clear
    }
}
