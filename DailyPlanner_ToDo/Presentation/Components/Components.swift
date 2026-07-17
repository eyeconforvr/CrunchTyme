//
//  Components.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/07/14.
//

import SwiftUI

struct Components: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WeatherTray : View
{
     var viewModel : WeatherViewModel

    
//    init(viewModel: WeatherViewModel, body: some View) {
//        self.viewModel = viewModel
//            
//    }

    
    var body : some View
    {
        
//        todaysWeather = "\(viewModel.$currentTemp)/°C"
    
        Grid()
        {
            GridRow()
            {
                Text("\(viewModel.currentTemp)°C")
                
                VStack
                {
                    ZStack{
                        HStack{
                            Image(systemName: "sunrise")
                            Text("Sunrise Time")
                        }
                    }
                    
                    ZStack{
                        HStack{
                            Image(systemName: "sunset")
                            Text("Sunset Time")
                        }
                    }
                }
            }
            
            .padding(30)
            
            
        }.background(.gray.opacity(0.15)).cornerRadius(20)
    }
}


#Preview {
//    WeatherTray()
}
