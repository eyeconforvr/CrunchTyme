//
//  DailyForecastView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct DailyForecastView: View {
    var viewModel: WeatherViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {

                ForEach(viewModel.weather.dailyForecast, id: \.day) { forecast in
                    ForecastCard(
                        label: forecast.day,
                        highTemp: forecast.highTemp,
                        lowTemp: forecast.lowTemp,
                        icon: forecast.icon
                    )
                }
            }
        }
    }
}

#Preview {
//    DailyForecastView()
}
