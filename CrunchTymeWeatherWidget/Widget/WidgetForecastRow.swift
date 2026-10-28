//
//  WidgetForecastRow.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import SwiftUI

struct WidgetForecastRow: View {

    let forecasts: [SharedDailyForecast]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(
                forecasts.prefix(4),
                id: \.day
            ) { forecast in
                WidgetForecastCard(
                    forecast: forecast
                )
            }
        }
    }
}
