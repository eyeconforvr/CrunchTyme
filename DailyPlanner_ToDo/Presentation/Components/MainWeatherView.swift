//
//  MainWeatherView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/16.
//

import SwiftUI

struct MainWeatherView: View {
    
    var body: some View {
        
        
        HStack{
            
            VStack{
                
                HStack{
                    Image(systemName: "location.circle.fill")
                    Text("Sandton")
                }
                
                HStack{
                    Text("Sunny")
                    Image(systemName: "cloud.sun.rain.fill")
                }.font(.title)
                
            }.padding(.trailing).padding()
            
            
            
            VStack{
                Text("High : 20°C")
                Text("Low : 24°C")
            }.padding(.leading).padding()
            
        }.background(Color.gray.opacity(0.3)).cornerRadius(20)
    }
}

#Preview {
    MainWeatherView()
}
