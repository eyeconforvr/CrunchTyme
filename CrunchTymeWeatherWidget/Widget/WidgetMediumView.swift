//
//  WidgetMediumView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//


import SwiftUI

struct WidgetMediumView: View {

    let entry: SimpleEntry

    var body: some View {
        VStack(spacing: 8) {

            // MARK: - Current Weather

            VStack(spacing: 6) {

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
                        .font(.system(size: 26, weight: .semibold))
                }

                // MARK: - Sun Arc

                WidgetSunArcView(
                    sunrise: entry.sunrise,
                    sunset: entry.sunset,
                    currentTime: entry.date,
                    height: 55,
                    sunSize: 18
                )

                // MARK: - Sunrise / Sunset

                HStack {

                    HStack(spacing: 3) {

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

                    HStack(spacing: 3) {

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

            Divider()

            // MARK: - Forecast

            VStack(alignment: .leading, spacing: 6) {

                Text("Forecast")
                    .font(.caption)
                    .fontWeight(.medium)

                WidgetForecastRow(
                    forecasts: entry.dailyForecast
                )

                Spacer()
            }
        }
        .padding(12)
    }
}

