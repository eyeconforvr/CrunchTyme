//
//  CurrentWeatherHero.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/02.
//

import SwiftUI

struct CurrentWeatherHero: View {

    var viewModel: WeatherViewModel

    var body: some View {

        ZStack {

            // MARK: - Background

            WeatherAppearance.background(
                for: viewModel.weather.condition,
                isDay: viewModel.weather.isDay
            )

            // MARK: - Sun Cycle

            if let sunrise = WeatherTimeParser.date(
                from: viewModel.weather.sunrise
            ),
            let sunset = WeatherTimeParser.date(
                from: viewModel.weather.sunset
            ) {

                SunCycleView(
                    sunrise: sunrise,
                    sunset: sunset,
                    condition: viewModel.weather.condition,
                    temperature: viewModel.weather.currentTemp
                )
                .padding(.top, 35)
            }

            // MARK: - High / Low

            VStack {

                HStack {

                    HStack(spacing: 4) {
                        
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)

                        Text(viewModel.weather.lowTemp)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)

                    }

                    Spacer()

                    HStack(spacing: 4) {

                        Image(systemName: "arrow.up")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)

                        Text(viewModel.weather.highTemp)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                    }
                }

                Spacer()
            }
            .padding()

            // MARK: - Current Weather

            VStack {

                Spacer()

                CurrentWeatherCard(
                    viewModel: viewModel
                )

                Spacer()
                    .frame(height: 65)
            }

            // MARK: - Sunrise / Sunset

            VStack {

                Spacer()

                HStack {

                    VStack(alignment: .leading, spacing: 4) {

                        Text("Sunrise")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(viewModel.weather.sunrise)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {

                        Text("Sunset")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(viewModel.weather.sunset)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 310)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

#Preview {

    CurrentWeatherHero(
        viewModel: WeatherViewModel(
            weatherRepository: WeatherRepository(
                weatherService: WeatherService()
            )
        )
    )
}

