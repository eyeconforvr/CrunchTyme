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
            condition: "Mostly Clear",
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
            condition: "Mostly Clear",
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
                dailyForecast: []
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

        let entry = SimpleEntry(
            date: currentDate,
            temperature: weather.currentTemp,
            condition: weather.condition,
            location: "Sandton",
            sunrise: WeatherTimeParser.date(
                from: weather.sunrise
            ) ?? currentDate,
            sunset: WeatherTimeParser.date(
                from: weather.sunset
            ) ?? currentDate,
            dailyForecast: weather.dailyForecast
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

            WidgetSunArcView(
                sunrise: entry.sunrise,
                sunset: entry.sunset,
                currentTime: Calendar.current.date(
                    bySettingHour: 20,
                    minute: 30,
                    second: 0,
                    of: entry.date
                ) ?? entry.date,
                height: 75,
                sunSize: 20
            )

            // MARK: - Sunrise / Sunset

            HStack {

                HStack(spacing: 4) {

                    Image(systemName: "sunrise.fill")
                        .font(.caption2)

                    Text(
                        entry.sunrise.formatted(
                            date: .omitted,
                            time: .shortened
                        )
                    )
                    .font(.caption2)
                }

                Spacer()

                HStack(spacing: 4) {

                    Text(
                        entry.sunset.formatted(
                            date: .omitted,
                            time: .shortened
                        )
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
            WidgetExtraLargeView( entry: entry )

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

            if #available(iOS 17.0, *) {

                CrunchTymeWeatherWidgetFamilyView(
                    entry: entry
                )
                .containerBackground(
                    .fill.tertiary,
                    for: .widget
                )

            } else {

                CrunchTymeWeatherWidgetFamilyView(
                    entry: entry
                )
                .padding()
                .background()
            }
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
        condition: "Mostly Clear",
        location: "Sandton",
        sunrise: .now,
        sunset: .now,
        dailyForecast: []
    )
}

