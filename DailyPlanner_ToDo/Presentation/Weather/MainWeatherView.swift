//
//  MainWeatherView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI

struct MainWeatherView: View {
    @State var viewModel : WeatherViewModel
    
    var body: some View {
        GroupBox {
            LazyVGrid(columns: [
                .init(.flexible(), spacing: 16, alignment: .center),
                .init(.flexible(), spacing: 16, alignment: .center),
                .init(.flexible(), spacing: 16, alignment: .center)
            ]) {
                VStack {
                    HStack {
                        VStack {
                            Text("\(viewModel.weather.currentTemp)")
                            HStack {
                                Image(systemName: viewModel.weather.icon)
                                    .foregroundStyle(.white, .yellow, .white)
                                Text(viewModel.weather.condition)
                            }
                            .font(.caption)
                        }.foregroundStyle(Color.white)
                        
                    }
                    .font(.title)
                    
                }
                
                
                VStack {
                    Text("High: \(viewModel.weather.highTemp)")
                    Text("Low : \(viewModel.weather.lowTemp)")
                }.font(.subheadline).foregroundStyle(Color.white)
                
                VStack {
                    HStack{
                        Image(systemName: "sunrise").foregroundStyle(.white,.yellow)
                        Text("\(viewModel.weather.sunrise)")
                    }.foregroundStyle(Color.white)
                    HStack{
                        Image(systemName: "sunset").foregroundStyle(.white,.yellow)
                        Text("\(viewModel.weather.sunset)")
                    }
                }.font(.subheadline).foregroundStyle(Color.white)
                
                
            }
            .task {
                do {
                    try await viewModel.fetchWeather(city: "Sandton")
                    
                } catch {
                    print("Error fetching weather: \(error)")
                }
            }
            
        } label: {
            HStack {
                Text("Sandton")
                Image(systemName: "location.fill").font(.caption)
            }.frame(maxWidth: .infinity).foregroundStyle(Color.white)
        }
        .dynamicTypeSize(.xSmall ... .large).backgroundStyle(Color.accentColor.opacity(0.8))
    }
}


#Preview {
//    MainWeatherView()
//        .padding()
}
