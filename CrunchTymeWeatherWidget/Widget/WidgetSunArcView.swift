//
//  WidgetSunArcView.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/06.
//

import SwiftUI

struct WidgetSunArcView: View {

    let sunrise: Date
    let sunset: Date
    let currentTime: Date
    let height: CGFloat
    let sunSize: CGFloat

    // MARK: - Day Progress

    private var dayProgress: Double {

        let daylightDuration =
            sunset.timeIntervalSince(sunrise)

        guard daylightDuration > 0 else {
            return 0
        }

        return min(
            max(
                currentTime.timeIntervalSince(sunrise)
                    / daylightDuration,
                0
            ),
            1
        )
    }

    // MARK: - Night Progress

    private var nightProgress: Double {

        if currentTime > sunset {

            let nextSunrise =
                Calendar.current.date(
                    byAdding: .day,
                    value: 1,
                    to: sunrise
                ) ?? sunrise

            let nightDuration =
                nextSunrise.timeIntervalSince(sunset)

            guard nightDuration > 0 else {
                return 0
            }

            let elapsed =
                currentTime.timeIntervalSince(sunset)

            return min(
                max(
                    elapsed / nightDuration,
                    0
                ),
                1
            )
        }

        let previousSunset =
            Calendar.current.date(
                byAdding: .day,
                value: -1,
                to: sunset
            ) ?? sunset

        let nightDuration =
            sunrise.timeIntervalSince(previousSunset)

        guard nightDuration > 0 else {
            return 0
        }

        let elapsed =
            currentTime.timeIntervalSince(previousSunset)

        return min(
            max(
                elapsed / nightDuration,
                0
            ),
            1
        )
    }

    // MARK: - Day / Night

    private var isDaytime: Bool {

        currentTime >= sunrise &&
        currentTime <= sunset
    }

    // MARK: - Moon Position

    private var moonProgress: Double {

        // sunset = 0 → left side
        // sunrise = 1 → right side

        return nightProgress
    }

    // MARK: - Body

    var body: some View {

        GeometryReader { geometry in

            let width = geometry.size.width

            ZStack {

                // MARK: - Background Arc

                WidgetArcShape()
                    .stroke(
                        isDaytime
                            ? .orange.opacity(0.18)
                            : .blue.opacity(0.18),
                        lineWidth: 8
                    )

                // MARK: - Active Arc

                if isDaytime {

                    WidgetArcShape()
                        .trim(
                            from: 0,
                            to: dayProgress
                        )
                        .stroke(
                            .orange.opacity(0.9),
                            style: StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round
                            )
                        )

                } else {

                    WidgetArcShape()
                        .trim(
                            from: 0,
                            to: moonProgress
                        )
                        .stroke(
                            .blue.opacity(0.9),
                            style: StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round
                            )
                        )
                }

                // MARK: - Current Sun / Moon

                Image(
                    systemName: isDaytime
                        ? "sun.max.fill"
                        : "moon.stars.fill"
                )
                .font(
                    .system(size: sunSize)
                )
                .foregroundStyle(
                    isDaytime
                        ? .yellow
                        : .blue
                )
                .position(
                    x: positionX(
                        width: width,
                        progress: isDaytime
                            ? dayProgress
                            : moonProgress
                    ),
                    y: positionY(
                        height: height,
                        progress: isDaytime
                            ? dayProgress
                            : moonProgress
                    )
                )
            }
        }
        .frame(height: height)
    }

    // MARK: - Horizontal Position

    private func positionX(
        width: CGFloat,
        progress: Double
    ) -> CGFloat {

        let t = progress

        let startX = 0.0
        let endX = width

        let control1X = width * 0.25
        let control2X = width * 0.75

        return CGFloat(

            pow(1 - t, 3) * startX

            + 3
            * pow(1 - t, 2)
            * t
            * control1X

            + 3
            * (1 - t)
            * pow(t, 2)
            * control2X

            + pow(t, 3)
            * endX
        )
    }

    // MARK: - Vertical Position

    private func positionY(
        height: CGFloat,
        progress: Double
    ) -> CGFloat {

        let t = progress

        let startY = Double(height - 5)
        let endY = Double(height - 5)

        let control1Y = 5.0
        let control2Y = 5.0

        return CGFloat(

            pow(1 - t, 3) * startY

            + 3
            * pow(1 - t, 2)
            * t
            * control1Y

            + 3
            * (1 - t)
            * pow(t, 2)
            * control2Y

            + pow(t, 3)
            * endY
        )
    }
}
