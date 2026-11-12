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
