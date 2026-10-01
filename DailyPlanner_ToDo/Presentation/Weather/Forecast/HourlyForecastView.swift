//
//  HourlyForecastView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct HourlyForecastView: View {

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {

                ForEach(0..<24, id: \.self) { _ in
                    ForecastCard()
                }
            }
        }
    }
}

#Preview {
    HourlyForecastView()
}
