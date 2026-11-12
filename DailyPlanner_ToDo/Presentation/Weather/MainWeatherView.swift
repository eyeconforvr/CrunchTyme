//
//  MainWeatherScreen.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/12.
//

import SwiftUI

struct MainWeatherScreen: View {

    var weatherViewModel: WeatherViewModel

    var body: some View {

        ScrollView {

            VStack(spacing: 12) {

                CurrentWeatherHero(
                    viewModel: weatherViewModel
                )

                ForecastView(
                    viewModel: weatherViewModel
                )

                WeatherInfoTilesView(humidity: weatherViewModel.weather.metrics.humidity)
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {

    MainWeatherScreen(
        weatherViewModel: WeatherViewModel(
            weatherRepository: WeatherRepository(
                weatherService: WeatherService()
            )
        )
    )
}
