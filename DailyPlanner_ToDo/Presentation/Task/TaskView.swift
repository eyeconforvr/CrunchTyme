//
//  TaskView.swift
//  DailyPlanner_ToDo
//

import SwiftUI

struct TaskView: View {

    @State private var isSheetPresented = false

    var taskViewModel: TaskViewModel
    var weatherViewModel: WeatherViewModel

    private var currentDate: Date {
        Date()
    }

    private var greeting: String {
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

    private var dateText: String {
        currentDate.formatted(
            .dateTime.weekday(.wide).month(.wide).day()
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
                                .font(.system(size: 13, weight: .bold))
                                .tracking(2.5)
                                .foregroundStyle(
                                    Color("Text").opacity(0.5)
                                )

                            Text("\(greeting), AJ")
                                .font(.system(
                                    size: 30,
                                    weight: .bold,
                                    design: .rounded
                                ))
                                .tracking(-1.2)
                                .foregroundStyle(Color("Text"))
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
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
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
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

