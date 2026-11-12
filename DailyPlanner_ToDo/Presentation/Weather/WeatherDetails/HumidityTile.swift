//
//  HumidityTile.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct HumidityTile: View {
    var humidity: Double? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "humidity")
                .font(.title2)
                .foregroundStyle(Color("Button"))

            Text("Humidity")
                .font(.caption)
                .foregroundStyle(Color("Text").opacity(0.6))

            Text(humidity.map { String(format: "%.0f%%", $0) } ?? "--")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .padding()
        .foregroundStyle(Color("Text"))
        .background(Color("Container"))
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(Color.gray), lineWidth: 1)
        }
    }
}

#Preview {
    HumidityTile()
}
