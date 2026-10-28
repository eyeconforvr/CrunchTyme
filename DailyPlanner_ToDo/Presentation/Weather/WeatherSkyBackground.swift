//
//  WeatherSkyBackground.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/12.
//

import SwiftUI

struct WeatherSkyBackground: View {

    let condition: String
    let isDay: Bool

    var body: some View {
        ZStack {
            // WeatherAppearance gradients fade to .clear, which lets the
            // host background show through and makes the sky look like it
            // stops early. An opaque base makes the layer fill its whole
            // frame, so it starts and ends exactly where the container does.
            Color(uiColor: .systemBackground)

            WeatherAppearance.background(
                for: condition,
                isDay: isDay
            )

            WeatherAtmosphereView(
                condition: condition,
                isDay: isDay
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

#Preview("Sky – Partly Cloudy Day") {
    WeatherSkyBackground(condition: "Partly cloudy", isDay: true)
        .frame(height: 310)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding()
}
