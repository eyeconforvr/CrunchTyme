//
//  WeatherAtmosphereView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/12.
//

import SwiftUI

struct WeatherAtmosphereView: View {

    let condition: String
    let isDay: Bool

    private var weather: String {
        condition.lowercased()
    }

    private var isThunderstorm: Bool {
        weather.contains("thunder") || weather.contains("storm")
    }

    private var isBlizzard: Bool {
        weather.contains("blizzard")
    }

    private var isSnowy: Bool {
        weather.contains("snow")
            || weather.contains("sleet")
            || weather.contains("ice pellets")
            || isBlizzard
    }

    private var isFoggy: Bool {
        weather.contains("fog")
            || weather.contains("mist")
            || weather.contains("haze")
    }

    private var isRainy: Bool {
        weather.contains("rain")
            || weather.contains("drizzle")
            || weather.contains("shower")
            || isThunderstorm
    }

    private var isPartlyCloudy: Bool {
        weather.contains("partly cloudy")
            || weather.contains("partlycloudy")
    }

    private var isClear: Bool {
        weather.contains("clear")
    }

    private var isSunny: Bool {
        weather.contains("sunny") || weather == "sun"
    }

    private var isCloudy: Bool {
        weather.contains("cloud")
            || weather.contains("overcast")
            || isFoggy
            || isRainy
            || isSnowy
    }

    private var showsSun: Bool {
        isDay && (isSunny || isClear || isPartlyCloudy)
    }

    private var showsMoon: Bool {
        !isDay && (isClear || isSunny || isPartlyCloudy)
    }

    private var rainIntensity: Double {
        if isThunderstorm || weather.contains("heavy rain") {
            return 0.48
        }

        if weather.contains("moderate") {
            return 0.36
        }

        return 0.26
    }

    private var snowIntensity: Double {
        if isBlizzard || weather.contains("heavy snow") {
            return 0.75
        }

        if weather.contains("moderate snow") {
            return 0.55
        }

        return 0.40
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack {

                // Broad atmospheric colour across the entire hero
                atmosphereWash
                    .frame(width: size.width, height: size.height)

                // Wide, soft lighting instead of a small isolated glow
                if showsSun {
                    sunGlow
                        .frame(
                            width: size.width * 1.25,
                            height: size.height * 1.55
                        )
                        .position(
                            x: size.width * 0.76,
                            y: size.height * 0.18
                        )

                    sun
                        .frame(
                            width: min(size.width * 0.28, 112),
                            height: min(size.width * 0.28, 112)
                        )
                        .position(
                            x: size.width * 0.79,
                            y: size.height * 0.22
                        )
                }

                // Night glow spreads across the sky
                if !isDay {
                    nightGlow
                        .frame(
                            width: size.width * 1.3,
                            height: size.height * 1.5
                        )
                        .position(
                            x: size.width * 0.72,
                            y: size.height * 0.20
                        )

                    if showsMoon {
                        moon
                            .frame(
                                width: min(size.width * 0.13, 48),
                                height: min(size.width * 0.13, 48)
                            )
                            .position(
                                x: size.width * 0.78,
                                y: size.height * 0.22
                            )
                    }

                    if !isRainy && !isSnowy && !isFoggy {
                        stars(in: size)
                    }
                }

                // Cloud banks span different parts of the hero
                if isCloudy || isPartlyCloudy {
                    cloudLayer(in: size)
                }

                // Haze reaches across the card, not just the centre
                if isFoggy {
                    fogLayer(in: size)
                }

                // Precipitation is distributed over the full hero
                if isRainy {
                    precipitation(in: size, isSnow: false)
                        .opacity(rainIntensity)
                }

                if isSnowy {
                    precipitation(in: size, isSnow: true)
                        .opacity(snowIntensity)
                }

                if isThunderstorm {
                    lightning(in: size)
                }
            }
            .frame(width: size.width, height: size.height)
            .clipped()
            .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Atmosphere Wash

    private var atmosphereWash: some View {
        LinearGradient(
            stops: [
                .init(
                    color: atmosphereTint.opacity(isDay ? 0.18 : 0.24),
                    location: 0
                ),
                .init(
                    color: atmosphereTint.opacity(isDay ? 0.09 : 0.13),
                    location: 0.48
                ),
                .init(
                    color: atmosphereTint.opacity(isDay ? 0.03 : 0.08),
                    location: 1
                )
            ],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }

    private var atmosphereTint: Color {
        if isThunderstorm {
            return Color.indigo
        }

        if isSnowy {
            return Color.cyan
        }

        if isFoggy || isCloudy {
            return isDay ? Color.white : Color.blue
        }

        if !isDay {
            return Color.purple
        }

        return Color.orange
    }

    // MARK: - Sunlight

    private var sunGlow: some View {
        RadialGradient(
            stops: [
                .init(color: .yellow.opacity(0.34), location: 0),
                .init(color: .orange.opacity(0.19), location: 0.38),
                .init(color: .orange.opacity(0.07), location: 0.68),
                .init(color: .clear, location: 1)
            ],
            center: .center,
            startRadius: 0,
            endRadius: 220
        )
    }

    private var sun: some View {
        GeometryReader { geometry in
            let side = min(geometry.size.width, geometry.size.height)

            ZStack {
                ForEach(0..<8, id: \.self) { index in
                    Capsule()
                        .fill(Color.yellow.opacity(0.38))
                        .frame(
                            width: max(2, side * 0.035),
                            height: side * 0.14
                        )
                        .offset(y: -side * 0.36)
                        .rotationEffect(
                            .degrees(Double(index) * 45)
                        )
                }

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .yellow,
                                .orange.opacity(0.9)
                            ],
                            center: .topLeading,
                            startRadius: 2,
                            endRadius: side * 0.5
                        )
                    )
                    .frame(
                        width: side * 0.48,
                        height: side * 0.48
                    )
                    .shadow(
                        color: .orange.opacity(0.35),
                        radius: side * 0.15
                    )
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
    }

    // MARK: - Night Sky

    private var nightGlow: some View {
        RadialGradient(
            colors: [
                Color.purple.opacity(0.25),
                Color.indigo.opacity(0.15),
                Color.blue.opacity(0.06),
                Color.clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 240
        )
    }

    private var moon: some View {
        GeometryReader { geometry in
            let side = min(geometry.size.width, geometry.size.height)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white,
                                Color(
                                    red: 0.76,
                                    green: 0.82,
                                    blue: 1
                                )
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Circle()
                    .fill(
                        Color(
                            red: 0.13,
                            green: 0.12,
                            blue: 0.30
                        )
                    )
                    .frame(
                        width: side * 0.83,
                        height: side * 0.83
                    )
                    .offset(
                        x: side * 0.32,
                        y: -side * 0.19
                    )
            }
            .frame(
                width: side,
                height: side
            )
            .shadow(color: .white.opacity(0.22), radius: 10)
        }
    }

    // MARK: - Stars

    private func stars(in size: CGSize) -> some View {
        ZStack {
            star(0.09, 0.16, 3, in: size)
            star(0.23, 0.32, 2, in: size)
            star(0.38, 0.13, 3, in: size)
            star(0.48, 0.27, 2, in: size)
            star(0.61, 0.10, 2, in: size)
            star(0.92, 0.13, 3, in: size)
            star(0.91, 0.39, 2, in: size)
            star(0.13, 0.46, 2, in: size)
            star(0.57, 0.40, 3, in: size)
            star(0.75, 0.48, 2, in: size)
        }
    }

    private func star(
        _ x: CGFloat,
        _ y: CGFloat,
        _ diameter: CGFloat,
        in size: CGSize
    ) -> some View {
        Circle()
            .fill(.white.opacity(0.85))
            .frame(width: diameter, height: diameter)
            .shadow(color: .white.opacity(0.35), radius: 4)
            .position(
                x: size.width * x,
                y: size.height * y
            )
    }

    // MARK: - Clouds

    private func cloudLayer(in size: CGSize) -> some View {
        ZStack {
            if isPartlyCloudy && !isRainy && !isSnowy {
                // Separate cloud groups leave the sky visible
                cloud(
                    width: size.width * 0.38,
                    height: size.height * 0.18,
                    opacity: isDay ? 0.48 : 0.24
                )
                .position(
                    x: size.width * 0.77,
                    y: size.height * 0.30
                )

                cloud(
                    width: size.width * 0.28,
                    height: size.height * 0.13,
                    opacity: isDay ? 0.30 : 0.18
                )
                .position(
                    x: size.width * 0.30,
                    y: size.height * 0.42
                )
            } else {
                // Wider cloud banks for overcast and wet weather
                cloud(
                    width: size.width * 0.65,
                    height: size.height * 0.23,
                    opacity: isThunderstorm
                        ? 0.38
                        : (isDay ? 0.30 : 0.22)
                )
                .position(
                    x: size.width * 0.76,
                    y: size.height * 0.28
                )

                cloud(
                    width: size.width * 0.58,
                    height: size.height * 0.19,
                    opacity: isThunderstorm
                        ? 0.32
                        : (isDay ? 0.23 : 0.17)
                )
                .position(
                    x: size.width * 0.23,
                    y: size.height * 0.43
                )

                cloud(
                    width: size.width * 0.72,
                    height: size.height * 0.18,
                    opacity: isThunderstorm ? 0.20 : 0.12
                )
                .position(
                    x: size.width * 0.70,
                    y: size.height * 0.53
                )
            }
        }
    }

    private func cloud(
        width: CGFloat,
        height: CGFloat,
        opacity: Double
    ) -> some View {
        ZStack {
            Ellipse()
                .fill(.white.opacity(opacity))
                .frame(
                    width: width,
                    height: height * 0.55
                )
                .offset(y: height * 0.15)

            Circle()
                .fill(.white.opacity(opacity))
                .frame(
                    width: height * 0.78,
                    height: height * 0.78
                )
                .offset(
                    x: -width * 0.23,
                    y: -height * 0.02
                )

            Circle()
                .fill(.white.opacity(opacity))
                .frame(
                    width: height,
                    height: height
                )
                .offset(
                    x: -width * 0.04,
                    y: -height * 0.18
                )

            Circle()
                .fill(.white.opacity(opacity))
                .frame(
                    width: height * 0.76,
                    height: height * 0.76
                )
                .offset(
                    x: width * 0.21,
                    y: -height * 0.01
                )
        }
        .frame(width: width, height: height)
        .blur(radius: 1.5)
    }

    // MARK: - Fog

    private func fogLayer(in size: CGSize) -> some View {
        VStack(spacing: size.height * 0.045) {
            ForEach(0..<5, id: \.self) { index in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.01),
                                .white.opacity(isDay ? 0.20 : 0.12),
                                .white.opacity(0.03),
                                .white.opacity(isDay ? 0.16 : 0.09),
                                .white.opacity(0.01)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: size.width * 1.15,
                        height: size.height * (0.035 + CGFloat(index) * 0.008)
                    )
                    .offset(
                        x: index.isMultiple(of: 2)
                            ? -size.width * 0.08
                            : size.width * 0.08
                    )
            }
        }
        .frame(width: size.width, height: size.height)
        .position(
            x: size.width * 0.5,
            y: size.height * 0.55
        )
        .blur(radius: 6)
    }

    // MARK: - Rain and Snow

    private func precipitation(
        in size: CGSize,
        isSnow: Bool
    ) -> some View {
        Canvas { context, canvasSize in
            let count: Int

            if isSnow {
                count = isBlizzard ? 75 : 48
            } else {
                count = isThunderstorm ? 65 : 52
            }

            for index in 0..<count {
                // Spread precipitation across the complete hero
                let xFraction = CGFloat(
                    (index * 37 + 11) % 101
                ) / 100

                let yFraction = CGFloat(
                    (index * 61 + 17) % 101
                ) / 100

                let x = xFraction * canvasSize.width
                let y = yFraction * canvasSize.height

                if isSnow {
                    let diameter: CGFloat = isBlizzard ? 4 : 3

                    let flake = CGRect(
                        x: x,
                        y: y,
                        width: diameter,
                        height: diameter
                    )

                    context.fill(
                        Path(ellipseIn: flake),
                        with: .color(.white.opacity(0.85))
                    )
                } else {
                    var path = Path()

                    path.move(to: CGPoint(x: x, y: y))

                    path.addLine(
                        to: CGPoint(
                            x: x - 5,
                            y: y + (isThunderstorm ? 21 : 15)
                        )
                    )

                    context.stroke(
                        path,
                        with: .color(.white.opacity(0.85)),
                        lineWidth: isThunderstorm ? 1.2 : 0.9
                    )
                }
            }
        }
        .frame(width: size.width, height: size.height)
    }

    // MARK: - Lightning

    private func lightning(in size: CGSize) -> some View {
        Image(systemName: "bolt.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(
                LinearGradient(
                    colors: [.yellow, .orange],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .yellow.opacity(0.6), radius: 12)
            .frame(
                width: min(size.width * 0.13, 42),
                height: size.height * 0.25
            )
            .position(
                x: size.width * 0.69,
                y: size.height * 0.39
            )
            .opacity(0.85)
    }
}

#Preview("Partly Cloudy Day") {
    ZStack {
        WeatherAppearance.background(
            for: "Partly cloudy",
            isDay: true
        )

        WeatherAtmosphereView(
            condition: "Partly cloudy",
            isDay: true
        )
    }
    .frame(height: 310)
    .clipShape(RoundedRectangle(cornerRadius: 24))
}

#Preview("Thunderstorm") {
    ZStack {
        WeatherAppearance.background(
            for: "Thunderstorm",
            isDay: false
        )

        WeatherAtmosphereView(
            condition: "Thunderstorm",
            isDay: false
        )
    }
    .frame(height: 310)
    .clipShape(RoundedRectangle(cornerRadius: 24))
}
