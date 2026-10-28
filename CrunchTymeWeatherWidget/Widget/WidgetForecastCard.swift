//
//  WidgetForecast.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import SwiftUI

struct WidgetForecastCard: View {

    let forecast: SharedDailyForecast
    private let dayName: DayFiltering = DayNameUseCase()

    var body: some View {
        VStack(spacing: 4) {

            Text(dayName.abbreviateDay(forecast.day))
                .font(.caption2)
                .fontWeight(.medium)

            Image(systemName: forecast.icon)
                .font(.system(size: 16))

            Text(forecast.highTemp)
                .font(.caption)
                .fontWeight(.semibold)

            Text(forecast.lowTemp)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
