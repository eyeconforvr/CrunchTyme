//
//  CurrentWeatherCard.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct CurrentWeatherCard: View {

    var viewModel: WeatherViewModel

    var body: some View {

        VStack(spacing: 4) {

            Text(viewModel.weather.currentTemp)
                .font(.system(size: 60, weight: .heavy))

            Text(viewModel.weather.condition)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {

    CurrentWeatherCard(
        viewModel: WeatherViewModel(
            weatherRepository: WeatherRepository(
                weatherService: WeatherService()
            )
        )
    )
}

