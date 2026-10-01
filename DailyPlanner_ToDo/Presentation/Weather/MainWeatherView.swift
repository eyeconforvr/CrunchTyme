//
//  MainWeatherScreen.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/12.
//

import SwiftUI

struct MainWeatherScreen: View {
    var weatherViewModel: WeatherViewModel
    
    private var sunrise: Date? {
        WeatherTimeParser.date(
            from: weatherViewModel.weather.sunrise
        )
    }

    private var sunset: Date? {
        WeatherTimeParser.date(
            from: weatherViewModel.weather.sunset
        )
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {

                CurrentWeatherCard(viewModel: weatherViewModel)

                ForecastView()

                WeatherInfoTilesView()

                if let sunrise = sunrise,
                    let sunset = sunset
                {
                SunCycleView(sunrise: sunrise,sunset: sunset,
                             condition: weatherViewModel.weather.condition,
                                 temperature: weatherViewModel.weather.currentTemp
                )
                }
            }
            .padding(.horizontal, 10)
        }.onAppear {
            print("SUNRISE:", weatherViewModel.weather.sunrise)
            print("SUNSET:", weatherViewModel.weather.sunset)
        }
    }
}

#Preview {
    MainWeatherScreen(weatherViewModel : WeatherViewModel(weatherRepository: WeatherRepository(weatherService: WeatherService())))
}
