//
//  WeatherBackgroundView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/12.
//

import SwiftUI

struct WeatherBackgroundView: View {
    let condition: String
    let isDay: Bool

    private var isRainy: Bool {
        let condition = condition.lowercased()
        return condition.contains("rain")
            || condition.contains("drizzle")
            || condition.contains("storm")
            || condition.contains("thunder")
    }

    private var isCloudy: Bool {
        let condition = condition.lowercased()
        return condition.contains("cloud")
            || condition.contains("overcast")
            || condition.contains("fog")
            || condition.contains("mist")
    }

    private var gradientColors: [Color] {
        if !isDay {
            if isRainy {
                return [
                    Color(red: 0.035, green: 0.065, blue: 0.12),
                    Color(red: 0.10, green: 0.15, blue: 0.24),
                    Color(red: 0.07, green: 0.09, blue: 0.17)
                ]
            }

            return [
                Color(red: 0.055, green: 0.07, blue: 0.18),
                Color(red: 0.15, green: 0.13, blue: 0.31),
                Color(red: 0.09, green: 0.12, blue: 0.25)
            ]
        }

        if isRainy {
            return [
                Color(red: 0.20, green: 0.31, blue: 0.40),
                Color(red: 0.30, green: 0.39, blue: 0.48),
                Color(red: 0.13, green: 0.20, blue: 0.29)
            ]
        }

        if isCloudy {
            return [
                Color(red: 0.30, green: 0.43, blue: 0.54),
                Color(red: 0.43, green: 0.52, blue: 0.60),
                Color(red: 0.20, green: 0.29, blue: 0.40)
            ]
        }

        // Clear or sunny daytime
        return [
            Color(red: 0.16, green: 0.43, blue: 0.65),
            Color(red: 0.36, green: 0.61, blue: 0.76),
            Color(red: 0.83, green: 0.57, blue: 0.40)
        ]
    }

    private var glowColor: Color {
        if !isDay {
            return isRainy ? .blue : .purple
        }

        if isRainy || isCloudy {
            return .cyan
        }

        return .orange
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Layer 1: Rich atmospheric gradient
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Layer 2: Soft ambient lighting
                RadialGradient(
                    colors: [
                        glowColor.opacity(isDay ? 0.24 : 0.16),
                        .clear
                    ],
                    center: .init(x: 0.85, y: 0.12),
                    startRadius: 5,
                    endRadius: geometry.size.width * 1.1
                )

                // Layer 3: Fine grain texture
                Image("WeatherNoise")
                    .resizable(resizingMode: .tile)
                    .interpolation(.low)
                    .opacity(0.07)
                    .blendMode(.softLight)
                    .allowsHitTesting(false)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .clipped()
        }
        .ignoresSafeArea()
    }
}
