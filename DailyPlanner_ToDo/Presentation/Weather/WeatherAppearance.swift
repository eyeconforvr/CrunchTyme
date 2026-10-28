//
//  WeatherAppearance.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/07.
//

import SwiftUI

struct WeatherAppearance {

    // MARK: - Background Colors

    private struct BackgroundColors {

        let day: [Color]
        let night: [Color]
    }

    private static let backgrounds: [String: BackgroundColors] = [

        // MARK: - Sunny

        "Sunny": BackgroundColors(
            day: [
                .orange.opacity(0.30),
                .blue.opacity(0.15),
                .clear,
            ],
            night: [
                .indigo.opacity(0.45),
                .purple.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Clear

        "Clear": BackgroundColors(
            day: [
                .blue.opacity(0.35),
                .blue.opacity(0.15),
                .clear,
            ],
            night: [
                .indigo.opacity(0.50),
                .blue.opacity(0.25),
                .clear,
            ]
        ),

        // MARK: - Partly Cloudy

        "Partly cloudy": BackgroundColors(
            day: [
                .blue.opacity(0.25),
                .gray.opacity(0.15),
                .clear,
            ],
            night: [
                .indigo.opacity(0.40),
                .gray.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Cloudy

        "Cloudy": BackgroundColors(
            day: [
                .gray.opacity(0.30),
                .gray.opacity(0.15),
                .clear,
            ],
            night: [
                .gray.opacity(0.40),
                .indigo.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Overcast

        "Overcast": BackgroundColors(
            day: [
                .gray.opacity(0.30),
                .gray.opacity(0.15),
                .clear,
            ],
            night: [
                .gray.opacity(0.40),
                .indigo.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Mist

        "Mist": BackgroundColors(
            day: [
                .gray.opacity(0.25),
                .gray.opacity(0.10),
                .clear,
            ],
            night: [
                .gray.opacity(0.35),
                .indigo.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Fog

        "Fog": BackgroundColors(
            day: [
                .gray.opacity(0.25),
                .gray.opacity(0.10),
                .clear,
            ],
            night: [
                .gray.opacity(0.35),
                .indigo.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Freezing Fog

        "Freezing fog": BackgroundColors(
            day: [
                .white.opacity(0.30),
                .blue.opacity(0.15),
                .clear,
            ],
            night: [
                .blue.opacity(0.35),
                .indigo.opacity(0.25),
                .clear,
            ]
        ),

        // MARK: - Light Rain

        "Light rain": BackgroundColors(
            day: [
                .blue.opacity(0.30),
                .gray.opacity(0.15),
                .clear,
            ],
            night: [
                .indigo.opacity(0.45),
                .blue.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Moderate Rain

        "Moderate rain": BackgroundColors(
            day: [
                .blue.opacity(0.35),
                .indigo.opacity(0.20),
                .clear,
            ],
            night: [
                .indigo.opacity(0.50),
                .blue.opacity(0.25),
                .clear,
            ]
        ),

        // MARK: - Heavy Rain

        "Heavy rain": BackgroundColors(
            day: [
                .blue.opacity(0.40),
                .gray.opacity(0.20),
                .clear,
            ],
            night: [
                .indigo.opacity(0.55),
                .black.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Light Drizzle

        "Light drizzle": BackgroundColors(
            day: [
                .blue.opacity(0.25),
                .gray.opacity(0.15),
                .clear,
            ],
            night: [
                .indigo.opacity(0.40),
                .gray.opacity(0.20),
                .clear,
            ]
        ),

        // MARK: - Light Snow

        "Light snow": BackgroundColors(
            day: [
                .white.opacity(0.35),
                .blue.opacity(0.15),
                .clear,
            ],
            night: [
                .blue.opacity(0.35),
                .indigo.opacity(0.25),
                .clear,
            ]
        ),

        // MARK: - Moderate Snow

        "Moderate snow": BackgroundColors(
            day: [
                .white.opacity(0.40),
                .blue.opacity(0.20),
                .clear,
            ],
            night: [
                .blue.opacity(0.40),
                .indigo.opacity(0.30),
                .clear,
            ]
        ),

        // MARK: - Heavy Snow

        "Heavy snow": BackgroundColors(
            day: [
                .white.opacity(0.45),
                .blue.opacity(0.20),
                .clear,
            ],
            night: [
                .blue.opacity(0.45),
                .indigo.opacity(0.30),
                .clear,
            ]
        ),

        // MARK: - Blizzard

        "Blizzard": BackgroundColors(
            day: [
                .white.opacity(0.40),
                .gray.opacity(0.20),
                .clear,
            ],
            night: [
                .gray.opacity(0.40),
                .indigo.opacity(0.30),
                .clear,
            ]
        ),

        // MARK: - Thunderstorm

        "Thunderstorm": BackgroundColors(
            day: [
                .indigo.opacity(0.40),
                .purple.opacity(0.20),
                .clear,
            ],
            night: [
                .black.opacity(0.45),
                .indigo.opacity(0.35),
                .purple.opacity(0.15),
                .clear,
            ]
        ),
    ]

    // MARK: - Default

    private static let defaultBackground = BackgroundColors(
        day: [
            .blue.opacity(0.25),
            .clear,
        ],
        night: [
            .indigo.opacity(0.40),
            .blue.opacity(0.15),
            .clear,
        ]
    )

    // MARK: - Public Background

    static func background(
        for condition: String,
        isDay: Bool
    ) -> LinearGradient {

        let colors = backgrounds[condition] ?? defaultBackground

        return LinearGradient(
            colors: isDay ? colors.day : colors.night,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
