//
//  ForecastCard.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct ForecastCard: View {

    let label: String
    let highTemp: String
    let lowTemp: String
    let icon: String

    var body: some View {

        VStack(spacing: 6) {

            Text(label)
                .font(.caption)
                .bold()

            Image(systemName: icon)
                .font(.title)

            Text(highTemp)
                .font(.headline)

            Text(lowTemp)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 75, height: 105)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ForecastCard(
        label: "MON",
        highTemp: "28°C",
        lowTemp: "18°C",
        icon: "sun.max.fill"
    )
}
