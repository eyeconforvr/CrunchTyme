//
//  ForecastView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct ForecastView: View {

    enum ForecastMode {
        case daily
        case hourly
    }

    @State private var mode: ForecastMode = .daily

    var body: some View {
        VStack(spacing: 10) {

            Picker("Forecast", selection: $mode) {
                Text("7 Day")
                    .tag(ForecastMode.daily)

                Text("Hourly")
                    .tag(ForecastMode.hourly)
            }
            .pickerStyle(.segmented)

            switch mode {
            case .daily:
                DailyForecastView()

            case .hourly:
                HourlyForecastView()
            }
        }
    }
}

#Preview {
    ForecastView()
}
