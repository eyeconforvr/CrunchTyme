//
//  WeatherHeroSkeleton.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/29.
//

import SwiftUI

// MARK: - Shimmer

private struct ShimmerModifier: ViewModifier {

    let highlight: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceMotion {
                    GeometryReader { proxy in
                        let width = proxy.size.width

                        LinearGradient(
                            colors: [.clear, highlight, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: width * 0.6)
                        .offset(x: -width * 0.6 + phase * width * 1.6)
                    }
                    .allowsHitTesting(false)
                    .mask(content)
                }
            }
            .onAppear {
                guard !reduceMotion else { return }

                withAnimation(
                    .linear(duration: 1.4)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    /// Adds a sweeping highlight. Respects Reduce Motion.
    func shimmering(
        highlight: Color = Color.white.opacity(0.40)
    ) -> some View {
        modifier(ShimmerModifier(highlight: highlight))
    }
}

// MARK: - Building block

private struct SkeletonBlock: View {

    var width: CGFloat? = nil
    var height: CGFloat
    var radius: CGFloat = 8
    var tint: Color = Color.primary.opacity(0.10)

    var body: some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(tint)
            .frame(width: width, height: height)
    }
}

// MARK: - Tray skeleton

/// Mirrors WeatherTray: 330pt tall, 30pt corners, the same dark green
/// gradient, and the same layout (location, temperature, condition,
/// illustration, and the High / Low / Sunset stats row).
struct WeatherTraySkeleton: View {

    private let block = Color.white.opacity(0.16)

    var body: some View {
        GeometryReader { geometry in

            let availableWidth = geometry.size.width
            let isCompact = availableWidth < 360

            let illustrationSize = min(
                isCompact
                    ? availableWidth * 0.30
                    : availableWidth * 0.38,
                150
            )

            VStack(alignment: .leading, spacing: 24) {

                HStack(alignment: .top, spacing: 8) {

                    VStack(alignment: .leading, spacing: 12) {
                        SkeletonBlock(width: 96, height: 16, tint: block)

                        SkeletonBlock(
                            width: isCompact ? 130 : 150,
                            height: isCompact ? 56 : 66,
                            radius: 14,
                            tint: block
                        )

                        SkeletonBlock(width: 110, height: 16, tint: block)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Circle()
                        .fill(block)
                        .frame(
                            width: illustrationSize * 0.85,
                            height: illustrationSize * 0.85
                        )
                        .frame(
                            width: illustrationSize,
                            height: illustrationSize + 20
                        )
                }

                Spacer(minLength: 0)

                HStack(spacing: 0) {
                    statPlaceholder
                    statDivider
                    statPlaceholder
                    statDivider
                    statPlaceholder
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    .white.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 22)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                }
            }
            .padding(isCompact ? 16 : 22)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.31, blue: 0.25),
                        Color(red: 0.025, green: 0.18, blue: 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shimmering(highlight: Color.white.opacity(0.12))
            .shadow(
                color: Color(red: 0.08, green: 0.25, blue: 0.20)
                    .opacity(0.16),
                radius: 18,
                x: 0,
                y: 12
            )
            .frame(maxWidth: .infinity)
        }
        .frame(height: 330)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading weather")
    }

    private var statPlaceholder: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(block)
                .frame(width: 17, height: 17)

            SkeletonBlock(width: 42, height: 12, tint: block)
            SkeletonBlock(width: 28, height: 11, tint: block)
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(.white.opacity(0.14))
            .frame(width: 1, height: 35)
    }
}

// MARK: - Hero skeleton

/// Mirrors CurrentWeatherHero: same 310pt height, 24pt corners, and the
/// same layout (high/low, big temperature, sun arc, sunrise/sunset).
struct WeatherHeroSkeleton: View {

    var body: some View {
        ZStack {
            Color.primary.opacity(0.05)

            // Sun arc
            GeometryReader { proxy in
                let side = proxy.size.width - 48

                Circle()
                    .trim(from: 0.5, to: 1)
                    .stroke(
                        Color.primary.opacity(0.10),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: side, height: side)
                    .position(
                        x: proxy.size.width / 2,
                        y: proxy.size.height - 70
                    )
            }

            // High / low
            VStack {
                HStack {
                    SkeletonBlock(width: 72, height: 18)
                    Spacer()
                    SkeletonBlock(width: 72, height: 18)
                }
                Spacer()
            }
            .padding()

            // Temperature + condition
            VStack(spacing: 12) {
                Spacer()
                SkeletonBlock(width: 180, height: 56, radius: 14)
                SkeletonBlock(width: 110, height: 18)
                Spacer().frame(height: 65)
            }

            // Sunrise / sunset
            VStack {
                Spacer()

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        SkeletonBlock(width: 48, height: 12)
                        SkeletonBlock(width: 72, height: 16)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 6) {
                        SkeletonBlock(width: 48, height: 12)
                        SkeletonBlock(width: 72, height: 16)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 310)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shimmering()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading weather")
    }
}

#Preview("Tray skeleton") {
    WeatherTraySkeleton()
        .padding()
}

#Preview("Hero skeleton") {
    WeatherHeroSkeleton()
        .padding()
}
