//
//  MainWeatherView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI

struct WeatherTray: View {

    var viewModel: WeatherViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                WeatherTraySkeleton()
            } else {
                content
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
    }

    // MARK: - Content

    private var content: some View {
        GeometryReader { geometry in

            let availableWidth = geometry.size.width
            let isCompact = availableWidth < 360

            let illustrationSize = min(
                isCompact
                    ? availableWidth * 0.30
                    : availableWidth * 0.38,
                150
            )

            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Location and Weather

                HStack(alignment: .top, spacing: 8) {

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            viewModel.weather.locationName,
                            systemImage: "location"
                        )
                        .font(.system(
                            size: 15,
                            weight: .semibold
                        ))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)

                        Text("\(viewModel.weather.currentTemp)")
                            .font(.system(
                                size: isCompact ? 64 : 76,
                                weight: .light,
                                design: .rounded
                            ))
                            .tracking(-3)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )

                        Text(viewModel.weather.condition)
                            .font(.system(
                                size: isCompact ? 14 : 16,
                                weight: .medium
                            ))
                            .foregroundStyle(.white.opacity(0.75))
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                            .lineLimit(3)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .layoutPriority(1)

                    // MARK: Weather Illustration

                    weatherIllustration(size: illustrationSize)
                        .frame(
                            width: illustrationSize,
                            height: illustrationSize + 20
                        )
                        .clipped()
                        .accessibilityHidden(true)
                }

                Spacer(minLength: 0)

                // MARK: - Weather Statistics

                HStack(spacing: 0) {

                    weatherStat(
                        icon: "thermometer.high",
                        value: "\(viewModel.weather.highTemp)",
                        caption: "High"
                    )

                    statDivider

                    weatherStat(
                        icon: "thermometer.low",
                        value: "\(viewModel.weather.lowTemp)",
                        caption: "Low"
                    )

                    statDivider

                    weatherStat(
                        icon: "sunset",
                        value: "\(viewModel.weather.sunset)",
                        caption: "Sunset"
                    )
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    .white.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 22)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(
                            .white.opacity(0.12),
                            lineWidth: 1
                        )
                }
            }
            .padding(isCompact ? 16 : 22)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background {
                LinearGradient(
                    colors: [
                        Color(
                            red: 0.08,
                            green: 0.31,
                            blue: 0.25
                        ),
                        Color(
                            red: 0.025,
                            green: 0.18,
                            blue: 0.14
                        )
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 30)
            )
            .shadow(
                color: Color(
                    red: 0.08,
                    green: 0.25,
                    blue: 0.20
                )
                .opacity(0.16),
                radius: 18,
                x: 0,
                y: 12
            )
            .frame(maxWidth: .infinity)
        }
        .frame(height: 330)
    }

    // MARK: - Weather Illustration

    private func weatherIllustration(
        size: CGFloat
    ) -> some View {

        ZStack {

            Circle()
                .stroke(
                    .white.opacity(0.09),
                    lineWidth: 1
                )
                .frame(
                    width: size * 1.18,
                    height: size * 1.18
                )

            Circle()
                .stroke(
                    .white.opacity(0.13),
                    lineWidth: 1
                )
                .frame(
                    width: size * 0.92,
                    height: size * 0.92
                )

            Circle()
                .fill(
                    Color(
                        red: 1.0,
                        green: 0.83,
                        blue: 0.48
                    )
                )
                .frame(
                    width: size * 0.53,
                    height: size * 0.53
                )

            Image(systemName: viewModel.weather.icon)
                .symbolRenderingMode(.palette)
                .resizable()
                .scaledToFit()
                .foregroundStyle(
                    Color(
                        red: 0.59,
                        green: 0.39,
                        blue: 0.12
                    )
                )
                .frame(
                    width: size * 0.31,
                    height: size * 0.31
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Statistics Divider

    private var statDivider: some View {
        Rectangle()
            .fill(.white.opacity(0.14))
            .frame(width: 1, height: 35)
    }

    // MARK: - Statistics Item

    private func weatherStat(
        icon: String,
        value: String,
        caption: String
    ) -> some View {

        VStack(spacing: 6) {

            Image(systemName: icon)
                .font(.system(
                    size: 17,
                    weight: .medium
                ))
                .foregroundStyle(.white)

            Text(value)
                .font(.system(
                    size: 12,
                    weight: .semibold
                ))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(caption)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WeatherTray(
        viewModel: WeatherViewModel(
            weatherRepository: WeatherRepository(
                weatherService: WeatherService()
            )
        )
    )
    .padding()
    .background(Color("Background"))
}
