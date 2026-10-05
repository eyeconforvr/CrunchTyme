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

                WeatherInfoTilesView()
            }
            .padding(.horizontal, 10)
        }
        .onAppear {

            print(
                "SUNRISE:",
                weatherViewModel.weather.sunrise
            )

            print(
                "SUNSET:",
                weatherViewModel.weather.sunset
            )
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
