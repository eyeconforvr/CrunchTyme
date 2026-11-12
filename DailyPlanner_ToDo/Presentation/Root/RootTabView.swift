//
//  RootTabView.swift
//  Todo app — bottom navigation
//

import SwiftUI
import SwiftData

// MARK: - Tabs

enum AppTab: CaseIterable {
    case home, calendar, weather, settings

    var label: String {
        switch self {
        case .home: return "Home"
        case .calendar: return "Calendar"
        case .weather: return "Weather"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .calendar: return "calendar"
        case .weather: return "cloud.sun"
        case .settings: return "gearshape"
        }
    }
}

// MARK: - Root container

struct RootTabView: View {
    @Environment(LocationService.self) private var location
    @State private var selectedTab: AppTab = .home
    @Query private var tasks: [Task]
    @Environment(\.modelContext) private var context
    @State private var editingTask: Task?
    @State private var taskViewModel = TaskViewModel(filterProtocol: FilterUseCase())
    @State private var weatherViewModel = WeatherViewModel(
        weatherRepository: WeatherRepository(
            weatherService: WeatherService()
        )
    )

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.home.label, systemImage: AppTab.home.icon, value: AppTab.home) {
                HomeView(weatherViewModel: weatherViewModel)
            }

            Tab(AppTab.calendar.label, systemImage: AppTab.calendar.icon, value: AppTab.calendar) {
                CalendarView(
                    tasks: tasks,
                    onDelete: { try taskViewModel.deleteTask($0, context: context) },
                    onEdit: { editingTask = $0 }
                )
                .sheet(item: $editingTask) { task in
                    AddTaskView(taskToEdit: task)
                }
            }

            Tab(AppTab.weather.label, systemImage: AppTab.weather.icon, value: AppTab.weather) {
                NavigationStack {
                    MainWeatherScreen(weatherViewModel: weatherViewModel)
                }
            }

            Tab(AppTab.settings.label, systemImage: AppTab.settings.icon, value: AppTab.settings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
        .task(id: location.isGranted) {
            await loadWeather()
        }
        .onOpenURL { url in

                if url.scheme == "crunchtyme",
                   url.host == "weather" {

                    selectedTab = .weather
                }
            }
        
         
    }
    func loadWeather() async {
        var query = "Sandton" // Only used when device coordinates are unavailable.

        if location.isGranted {
            do {
                try await location.requestLocation()
            } catch {
                // A failed refresh must not discard a location already supplied by the device.
                print("Location refresh unavailable: \(error)")
            }
            query = location.coordinateQuery ?? query
        }

        guard !_Concurrency.Task.isCancelled else { return }
        do {
            try await weatherViewModel.fetchWeather(city: query)
        } catch is CancellationError {
            return
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
}



// MARK: - Placeholder destination views

struct HomeView: View {
    var taskViewModel = TaskViewModel(filterProtocol: FilterUseCase())
    var weatherViewModel : WeatherViewModel
    var body: some View {
        TaskView(taskViewModel: taskViewModel, weatherViewModel: weatherViewModel)
    }
}

struct WeatherView: View {
    var body: some View {
        placeholder(title: "Weather", systemImage: "cloud.sun")
    }
}

struct SettingsView: View {
    var body: some View {
        placeholder(title: "Settings", systemImage: "gearshape")
    }
}

@ViewBuilder
private func placeholder(title: String, systemImage: String) -> some View {
    ZStack {
        Theme.appBackground.ignoresSafeArea()
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 34, weight: .light))
                .foregroundColor(Theme.inkSoft)
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Theme.ink)
        }
    }
}

// MARK: - Preview

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
