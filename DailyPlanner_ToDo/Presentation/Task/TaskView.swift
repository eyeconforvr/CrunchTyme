//
//  TaskView.swift
//  DailyPlanner_ToDo
//

import SwiftUI

struct TaskView: View {

    @State private var isSheetPresented = false

    // Saved by OnboardingView
    @AppStorage("userName") private var userName = ""

    var taskViewModel: TaskViewModel
    var weatherViewModel: WeatherViewModel

    private var currentDate: Date {
        Date()
    }

    private var timeOfDayGreeting: String {
        let hour = Calendar.current.component(.hour, from: currentDate)

        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }

    private var trimmedName: String {
        userName.trimmingCharacters(in: .whitespacesAndNewlines)
    }


    private var dateText: String {
        currentDate.formatted(
            .dateTime.weekday(.abbreviated).month(.abbreviated).day()
        ).uppercased()
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Header

                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(dateText)
                                .font(.system(size: 12, weight: .bold))
                                .tracking(1.5)
                                .foregroundStyle(
                                    Color("Text").opacity(0.5)
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                Text(trimmedName.isEmpty
                                     ? timeOfDayGreeting
                                     : "\(timeOfDayGreeting),")
                                    .font(.system(
                                        size: trimmedName.isEmpty ? 24 : 18,
                                        weight: trimmedName.isEmpty ? .bold : .medium,
                                        design: .rounded
                                    ))
                                    .foregroundStyle(
                                        Color("Text").opacity(trimmedName.isEmpty ? 1 : 0.6)
                                    )

                                if !trimmedName.isEmpty {
                                    Text(trimmedName)
                                        .font(.system(
                                            size: 24,
                                            weight: .bold,
                                            design: .rounded
                                        ))
                                        .tracking(-0.5)
                                        .foregroundStyle(Color("Text"))
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }

                        Spacer(minLength: 4)

                        Button {
                            isSheetPresented = true
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.15))
                                    .frame(width: 58, height: 58)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .font(.system(
                                                size: 21,
                                                weight: .semibold
                                            ))
                                            .foregroundStyle(
                                                Color("Text")
                                            )
                                    }

                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 11, height: 11)
                                    .overlay {
                                        Circle()
                                            .stroke(
                                                Color("Background"),
                                                lineWidth: 2
                                            )
                                    }
                                    .offset(x: -1, y: 1)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Add a task")
                    }
                    .padding(.top, 12)

                    // MARK: Weather

                    WeatherTray(viewModel: weatherViewModel)

                    // MARK: Tasks and focus

                    TasksContainer(viewModel: taskViewModel)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }
            .background(Color("Background"))
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isSheetPresented) {
                AddTaskView()
            }
        }
    }
}

#Preview {
    TaskView(
        taskViewModel: TaskViewModel(
            filterProtocol: FilterUseCase()
        ),
        weatherViewModel: WeatherViewModel(
            weatherRepository: WeatherRepository(
                weatherService: WeatherService()
            )
        )
    )
}
