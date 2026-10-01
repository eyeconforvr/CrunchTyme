//
//  ForecastCard.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct ForecastCard: View {

    var body: some View {
        VStack(spacing: 6) {
            Text("MON")
                .font(.caption)
                .bold()

            Text("☀️")
                .font(.title)

            Text("28°")
                .font(.headline)

            Text("18°")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 75, height: 105)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ForecastCard()
}
