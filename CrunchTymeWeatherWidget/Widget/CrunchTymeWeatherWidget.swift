//
//  CrunchTymeWeatherWidget.swift
//  CrunchTymeWeatherWidget
//
//  Created by AJ Mhlanga on 2026/10/05.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {

        SimpleEntry(
            date: Date(),
            temperature: "28°C",
            condition: "Sunny",
            location: "Sandton",
            sunrise: Date(),
            sunset: Date(),
            dailyForecast: []
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> ()
    ) {

        let entry = SimpleEntry(
            date: Date(),
            temperature: "28°C",
            condition: "Sunny",
            location: "Sandton",
            sunrise: Date(),
            sunset: Date(),
            dailyForecast: []
        )

        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> ()
    ) {

        let currentDate = Date()

        guard let weather = WeatherDataStore.load() else {

            let entry = SimpleEntry(
                date: currentDate,
                temperature: "--",
                condition: "Weather unavailable",
                location: "Sandton",
                sunrise: currentDate,
                sunset: currentDate,
                dailyForecast: [],
                hasSunTimes: false
            )

            let timeline = Timeline(
                entries: [entry],
                policy: .after(
                    Calendar.current.date(
                        byAdding: .minute,
                        value: 30,
                        to: currentDate
                    ) ?? currentDate
                )
            )

            completion(timeline)
            return
        }

        let sunrise = weather.sunriseDate ?? WeatherTimeParser.date(from: weather.sunrise)
        let sunset = weather.sunsetDate ?? WeatherTimeParser.date(from: weather.sunset)
        let entry = SimpleEntry(
            date: currentDate,
            temperature: weather.currentTemp,
            condition: weather.condition,
            location: weather.locationName ?? "Sandton",
            sunrise: sunrise ?? currentDate,
            sunset: sunset ?? currentDate,
            dailyForecast: weather.dailyForecast,
            timeZoneIdentifier: weather.timeZoneIdentifier,
            hasSunTimes: sunrise != nil && sunset != nil
        )

        let timeline = Timeline(
            entries: [entry],
            policy: .after(
                Calendar.current.date(
                    byAdding: .minute,
                    value: 30,
                    to: currentDate
                ) ?? currentDate
            )
        )

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {

    let date: Date
    let temperature: String
    let condition: String
    let location: String
    let sunrise: Date
    let sunset: Date
    let dailyForecast: [SharedDailyForecast]
    var timeZoneIdentifier: String? = nil
    var hasSunTimes = true

    var sunriseLabel: String { timeLabel(sunrise) }
    var sunsetLabel: String { timeLabel(sunset) }

    private func timeLabel(_ date: Date) -> String {
        guard hasSunTimes else { return "--" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? "") ?? .current
        return formatter.string(from: date)
    }

    // MARK: - Day / Night

    var isDay: Bool {
        date >= sunrise && date < sunset
    }
}

struct CrunchTymeWeatherWidgetEntryView: View {

    var entry: Provider.Entry

    var body: some View {

        VStack(spacing: 0) {
            

            // MARK: - Top Weather Info

            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 2) {

                    Text(entry.location)
                        .font(.caption)
                        .fontWeight(.medium)

                    Text(entry.condition)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(entry.temperature)
                    .font(.system(size: 30, weight: .semibold))
            }

            // MARK: - Sun Arc

            if entry.hasSunTimes {
                WidgetSunArcView(
                    sunrise: entry.sunrise,
                    sunset: entry.sunset,
                    currentTime: entry.date,
                    height: 75,
                    sunSize: 20
                )
            }

            // MARK: - Sunrise / Sunset

            HStack {

                HStack(spacing: 4) {

                    Image(systemName: "sunrise.fill")
                        .font(.caption2)

                    Text(
                        entry.sunriseLabel
                    )
                    .font(.caption2)
                }

                Spacer()

                HStack(spacing: 4) {

                    Text(
                        entry.sunsetLabel
                    )
                    .font(.caption2)

                    Image(systemName: "sunset.fill")
                        .font(.caption2)
                }
            }
        }
        .padding(12)
        .widgetURL(
            URL(string: "crunchtyme://weather")
        )
    }
}

struct WidgetArcShape: Shape {

    func path(in rect: CGRect) -> Path {

        var path = Path()

        let startX = rect.minX
        let endX = rect.maxX
        let bottomY = rect.maxY - 5

        path.move(
            to: CGPoint(
                x: startX,
                y: bottomY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: endX,
                y: bottomY
            ),
            control1: CGPoint(
                x: startX + rect.width * 0.25,
                y: rect.minY + 5
            ),
            control2: CGPoint(
                x: endX - rect.width * 0.25,
                y: rect.minY + 5
            )
        )

        return path
    }
}

struct CrunchTymeWeatherWidgetFamilyView: View {

    @Environment(\.widgetFamily)
    private var widgetFamily

    let entry: SimpleEntry

    var body: some View {

        switch widgetFamily {

        case .systemLarge:

            WidgetMediumView(
                entry: entry
            )

        case .systemExtraLargePortrait:

            WidgetExtraLargeView(
                entry: entry
            )

        default:

            CrunchTymeWeatherWidgetEntryView(
                entry: entry
            )
        }
    }
}

struct CrunchTymeWeatherWidget: Widget {

    let kind: String = "CrunchTymeWeatherWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in

            CrunchTymeWeatherWidgetFamilyView(
                entry: entry
            )
            .containerBackground(
                WeatherAppearance.background(
                    for: entry.condition,
                    isDay: entry.isDay
                ),
                for: .widget
            )
        }

        .configurationDisplayName("Weather")

        .description(
            "Current weather and sun position."
        )
    }
}

#Preview(as: .systemSmall) {

    CrunchTymeWeatherWidget()

} timeline: {

    SimpleEntry(
        date: .now,
        temperature: "28°C",
        condition: "Sunny",
        location: "Sandton",
        sunrise: .now,
        sunset: .now,
        dailyForecast: []
    )
}

