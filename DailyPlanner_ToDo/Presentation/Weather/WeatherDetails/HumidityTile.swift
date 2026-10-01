//
//  HumidityTile.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct HumidityTile: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "humidity")
                .font(.title2)

            Text("Humidity")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("62%")
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
    HumidityTile()
}
