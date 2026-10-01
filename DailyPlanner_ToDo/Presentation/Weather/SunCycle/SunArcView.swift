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
            let centerY = height / 2

            let radius = min(
                width / 2 - 20,
                height / 2 - 10
            )

            ZStack {

                // MARK: - Day Arc

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
                    .gray.opacity(0.15),
                    lineWidth: 8
                )

                // Day elapsed
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
                    to: dayProgress
                )
                .stroke(
                    .orange.opacity(
                        isDaytime ? 0.8 : 0.2
                    ),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )

                // Day remaining
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
                    from: dayProgress,
                    to: 1
                )
                .stroke(
                    .orange.opacity(
                        isDaytime ? 0.25 : 0.08
                    ),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )

                // MARK: - Night Arc

                Path { path in
                    path.addArc(
                        center: CGPoint(
                            x: centerX,
                            y: centerY
                        ),
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(180),
                        clockwise: false
                    )
                }
                .stroke(
                    .blue.opacity(0.15),
                    lineWidth: 8
                )

                // Night elapsed
                Path { path in
                    path.addArc(
                        center: CGPoint(
                            x: centerX,
                            y: centerY
                        ),
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(180),
                        clockwise: false
                    )
                }
                .trim(
                    from: 0,
                    to: nightProgress
                )
                .stroke(
                    .blue.opacity(
                        isDaytime ? 0.08 : 0.7
                    ),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )

                // Night remaining
                Path { path in
                    path.addArc(
                        center: CGPoint(
                            x: centerX,
                            y: centerY
                        ),
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(180),
                        clockwise: false
                    )
                }
                .trim(
                    from: nightProgress,
                    to: 1
                )
                .stroke(
                    .blue.opacity(
                        isDaytime ? 0.08 : 0.2
                    ),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )

                // MARK: - Sunrise Marker

                Image(systemName: "sunrise.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.orange)
                    .position(
                        x: centerX - radius,
                        y: centerY
                    )

                // MARK: - Sunset Marker

                Image(systemName: "sunset.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.orange)
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
                            : .blue.opacity(glowAmount)
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
        .frame(height: 220)
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

        let x = centerX + cos(angle) * radius
        let y = centerY + sin(angle) * radius

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
