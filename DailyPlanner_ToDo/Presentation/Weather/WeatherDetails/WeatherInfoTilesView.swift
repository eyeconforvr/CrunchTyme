//
//  WeatherInfoTilesView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/09/30.
//

import SwiftUI

struct WeatherInfoTilesView: View {

    var body: some View {
        HStack(spacing: 10) {
           
                AirQualityTile()

                HumidityTile()
            
        }
    }
}

#Preview {
    WeatherInfoTilesView()
}
