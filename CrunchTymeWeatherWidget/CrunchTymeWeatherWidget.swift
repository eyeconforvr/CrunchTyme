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
            sunset: Date()
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
            sunset: Date()
        )

        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> ()
    ) {
        let currentDate = Date()

        let entry = SimpleEntry(
            date: currentDate,
            temperature: "28°C",
            condition: "Mostly Clear",
            location: "Sandton",
            sunrise: Date(),
            sunset: Date()
        )

        let timeline = Timeline(
            entries: [entry],
            policy: .atEnd
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

            ZStack {

                ArcShape()
                    .stroke(
                        .orange,
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round
                        )
                    )

                ZStack {
                    // Outer glow
                    Circle()
                        .fill(.orange.opacity(0.18))
                        .frame(width: 48, height: 48)
                        .blur(radius: 8)

                    // Inner glow
                    Circle()
                        .fill(.yellow.opacity(0.20))
                        .frame(width: 34, height: 34)
                        .blur(radius: 4)

                    // Sun
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.orange)
                }
                .offset(y: -18)
            }
            .frame(height: 75)

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
    }
}

struct ArcShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY - 5
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY - 5
            ),
            control1: CGPoint(
                x: rect.minX + rect.width * 0.25,
                y: rect.minY - 25
            ),
            control2: CGPoint(
                x: rect.maxX - rect.width * 0.25,
                y: rect.minY - 25
            )
        )

        return path
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
                CrunchTymeWeatherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CrunchTymeWeatherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Weather")
        .description("Current weather and sun position.")
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
        sunset: .now
    )
}

