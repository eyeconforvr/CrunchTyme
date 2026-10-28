//
//  SunArcView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/01.
//

import SwiftUI

struct SunArcView: View {

    let dayProgress: Double
    let nightProgress: Double
    let isDaytime: Bool
    let glowAmount: Double

    var body: some View {

        GeometryReader { geometry in

            let width = geometry.size.width
            let height = geometry.size.height

            let centerX = width / 2
            let centerY = height - 8

            let radius = width / 2 - 8

            ZStack {

                // MARK: - Background Arc

                Path { path in

                    path.addArc(
                        center: CGPoint(
                            x: centerX,
                            y: centerY
                        ),
                        radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(360),
                        clockwise: false
                    )
                }
                .stroke(
                    isDaytime
                        ? .orange.opacity(0.18)
                        : .blue.opacity(0.18),
                    lineWidth: 8
                )

                // MARK: - Active Arc

                Path { path in

                    path.addArc(
                        center: CGPoint(
                            x: centerX,
                            y: centerY
                        ),
                        radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(360),
                        clockwise: false
                    )
                }
                .trim(
                    from: 0,
                    to: isDaytime
                        ? dayProgress
                        : nightProgress
                )
                .stroke(
                    isDaytime
                        ? .orange.opacity(0.9)
                        : .blue.opacity(0.9),
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )

                // MARK: - Start Marker
                Image(
                    systemName: isDaytime
                        ? "sunrise.fill"
                        : "moonrise.fill"
                )
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    isDaytime
                        ? .orange
                        : .cyan
                )
                .shadow(
                    color: .black.opacity(0.6),
                    radius: 2,
                    x: 0,
                    y: 1
                )
                .position(
                    x: centerX - radius,
                    y: centerY
                )

                // MARK: - End Marker
                Image(
                    systemName: isDaytime
                        ? "sunset.fill"
                        : "moonset.fill"
                )
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    isDaytime
                        ? .orange
                        : .cyan
                )
                .shadow(
                    color: .black.opacity(0.6),
                    radius: 2,
                    x: 0,
                    y: 1
                )
                .position(
                    x: centerX + radius,
                    y: centerY
                )

                // MARK: - Sun / Moon

                ZStack {

                    Circle()
                        .fill(
                            isDaytime
                                ? .yellow.opacity(glowAmount)
                                : .white.opacity(glowAmount)
                        )
                        .frame(
                            width: 60,
                            height: 60
                        )
                        .blur(radius: 10)

                    Image(
                        systemName: isDaytime
                            ? "sun.max.fill"
                            : "moon.fill"
                    )
                    .font(.system(size: 28))
                    .foregroundStyle(
                        isDaytime
                            ? .yellow
                            : .blue
                    )
                }
                .position(
                    isDaytime
                        ? sunPosition(
                            centerX: centerX,
                            centerY: centerY,
                            radius: radius
                        )
                        : moonPosition(
                            centerX: centerX,
                            centerY: centerY,
                            radius: radius
                        )
                )
            }
        }
        .frame(height: 150)
    }

    // MARK: - Sun Position

    private func sunPosition(
        centerX: Double,
        centerY: Double,
        radius: Double
    ) -> CGPoint {

        let angle = Double.pi * dayProgress

        let x = centerX - cos(angle) * radius
        let y = centerY - sin(angle) * radius

        return CGPoint(
            x: x,
            y: y
        )
    }

    // MARK: - Moon Position

    private func moonPosition(
        centerX: Double,
        centerY: Double,
        radius: Double
    ) -> CGPoint {

        let angle = Double.pi * nightProgress

        let x = centerX - cos(angle) * radius
        let y = centerY - sin(angle) * radius

        return CGPoint(
            x: x,
            y: y
        )
    }
}

#Preview {

    SunArcView(
        dayProgress: 0.5,
        nightProgress: 0,
        isDaytime: true,
        glowAmount: 0.2
    )
}
