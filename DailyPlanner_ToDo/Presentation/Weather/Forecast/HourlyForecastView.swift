//
//  HourlyForecastView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct HourlyForecastView: View {

    var viewModel: WeatherViewModel

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 10) {

                ForEach(viewModel.weather.hourlyForecast, id: \.time) { forecast in

                    ForecastCard(
                        label: forecast.time,
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
//    HourlyForecastView()
}
