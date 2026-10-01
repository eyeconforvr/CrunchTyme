//
//  AirQualityTile.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct AirQualityTile: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "aqi.medium")
                .font(.title2)

            Text("Air Quality")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Good")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .padding()
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }
}

#Preview {
    AirQualityTile()
}
