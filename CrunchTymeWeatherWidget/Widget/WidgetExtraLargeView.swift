//
//  WidgetExtraLargeView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import SwiftUI

struct WidgetExtraLargeView: View {

    let entry: SimpleEntry

    var body: some View {
        VStack(spacing: 12) {

            // MARK: - Current Weather

            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 3) {

                    Text(entry.location)
                        .font(.headline)
                        .fontWeight(.medium)

                    Text(entry.condition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(entry.temperature)
                    .font(.system(size: 34, weight: .semibold))
            }

            // MARK: - Sun Arc

            if entry.hasSunTimes {
                WidgetSunArcView(
                    sunrise: entry.sunrise,
                    sunset: entry.sunset,
                    currentTime: entry.date,
                    height: 65,
                    sunSize: 22
                )
            }

            // MARK: - Sunrise / Sunset

            HStack {

                HStack(spacing: 4) {

                    Image(systemName: "sunrise.fill")
                        .font(.caption)

                    Text(
                        entry.sunriseLabel
                    )
                    .font(.caption)
                }

                Spacer()

                HStack(spacing: 4) {

                    Text(
                        entry.sunsetLabel
                    )
                    .font(.caption)

                    Image(systemName: "sunset.fill")
                        .font(.caption)
                }
            }

            Divider()

            // MARK: - Extended Forecast

            VStack(alignment: .leading, spacing: 8) {

                Text("Forecast")
                    .font(.subheadline)
                    .fontWeight(.medium)

                WidgetForecastRow(
                    forecasts: entry.dailyForecast
                )
            }

            Spacer()
        }
        .padding(16)
    }
}
