//
//  DailyForecastView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct DailyForecastView: View {

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {

                ForEach(0..<7, id: \.self) { _ in
                    ForecastCard()
                }
            }
        }
    }
}

#Preview {
    DailyForecastView()
}
