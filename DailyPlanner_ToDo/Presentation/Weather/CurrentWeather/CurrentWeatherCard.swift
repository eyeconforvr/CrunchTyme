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
        ZStack {

            // Atmospheric background
            LinearGradient(
                colors: [
                    .orange.opacity(0.85),
                    .orange.opacity(0.35),
                    .white.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Double-exposure sun
            Circle()
                .fill(.yellow.opacity(0.25))
                .frame(width: 220, height: 220)
                .blur(radius: 10)
                .offset(x: 100, y: -100)

            // Weather information
            VStack(spacing: 4) {
                Text(viewModel.weather.highTemp)
                    .font(.caption)
                    .bold()

                Text("Sandton")
                    .font(.headline)

                Text(viewModel.weather.currentTemp)
                    .font(.system(size: 80, weight: .medium))

                Text(viewModel.weather.condition)
                    .font(.headline)

                Spacer()

                Text(viewModel.weather.lowTemp)
                    .font(.caption)
                    .bold()
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity)
        .frame(height: 250)
    }
}
#Preview {
    CurrentWeatherCard(viewModel: WeatherViewModel(weatherRepository: WeatherRepository(weatherService: WeatherService())))
}
