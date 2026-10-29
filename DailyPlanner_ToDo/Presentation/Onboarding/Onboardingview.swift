//
//  Onboardingview.swift
//  DailyPlanner_ToDo
//
//  Created by AJ Mhlanga on 2026/10/28.
//

import SwiftUI

struct OnboardingView: View {

    @Environment(LocationService.self) private var location

    @AppStorage("userName") private var userName = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var step: Step = .welcome
    @State private var draftName = ""
    @FocusState private var nameFocused: Bool

    private enum Step: Int, CaseIterable {
        case welcome, name, location, storage, done
    }

    private var trimmedName: String {
        draftName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var displayName: String {
        trimmedName.isEmpty ? "friend" : trimmedName
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, 8)
                    .padding(.horizontal, 12)

                // Only the current page exists. No pager, so the keyboard
                // never forces five pages to re-layout while typing.
                ZStack {
                    pageContent(for: step)
                        .id(step)
                        .transition(.opacity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .simultaneousGesture(swipeGesture)

                actions
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Swipe

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 40)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height

                // Ignore mostly-vertical drags (scrolling, keyboard dismiss)
                guard abs(horizontal) > abs(vertical) * 1.5 else { return }

                if horizontal > 60 {
                    goBack()
                } else if horizontal < -60 {
                    advance()
                }
            }
    }

    // MARK: - Header (back button + progress)

    private var header: some View {
        ZStack {
            progressDots

            HStack {
                Button(action: goBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .opacity(step == .welcome ? 0 : 1)
                .disabled(step == .welcome)

                Spacer()
            }
        }
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(Step.allCases, id: \.rawValue) { dot in
                Capsule()
                    .fill(dot.rawValue <= step.rawValue
                          ? Color.primary.opacity(0.8)
                          : Color.primary.opacity(0.15))
                    .frame(width: dot == step ? 24 : 8, height: 8)
            }
        }
    }

    // MARK: - Background

    private var background: some View {
        LinearGradient(
            colors: stepColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(0.35)
        .background(Color(uiColor: .systemBackground))
    }

    private var stepColors: [Color] {
        switch step {
        case .welcome: return [.orange, .yellow]
        case .name: return [.pink, .orange]
        case .location: return [.blue, .cyan]
        case .storage: return [.indigo, .purple]
        case .done: return [.green, .mint]
        }
    }

    // MARK: - Page Content

    @ViewBuilder
    private func pageContent(for page: Step) -> some View {
        switch page {

        case .welcome:
            pageLayout(
                symbol: "hand.wave.fill",
                tint: .orange,
                title: "Hi there!",
                message: "I'm your new daily planner. I'm extremely organised, mildly dramatic, and I'm about to ask you for two favours. Don't worry, neither involves a kidney."
            )

        case .name:
            pageLayout(
                symbol: "person.crop.circle.badge.questionmark",
                tint: .pink,
                title: "What do we call you?",
                message: "\"Hey you\" gets old fast, and \"Dear User\" sounds like a tax letter."
            ) {
                VStack(spacing: 8) {
                    TextField("Your first name", text: $draftName)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .textContentType(.givenName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.continue)
                        .focused($nameFocused)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(uiColor: .secondarySystemBackground))
                        )
                        .onSubmit { advance() }
                        .onAppear {
                            // Wait for the page transition to finish so
                            // the keyboard doesn't fight the animation.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                nameFocused = true
                            }
                        }

                    Text("Stays on your phone. We wouldn't know where to send it anyway.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 32)
            }

        case .location:
            pageLayout(
                symbol: location.isGranted ? "checkmark.seal.fill" : "cloud.sun.fill",
                tint: .blue,
                title: "Favour #1: a peek at the sky",
                message: "I'd love your location so I can tell you whether it's jacket weather or \"why did I wash the car\" weather. Only while the app is open. I'm a weather nerd, not a stalker."
            ) {
                locationStatusNote
            }

        case .storage:
            pageLayout(
                symbol: "externaldrive.fill.badge.checkmark",
                tint: .indigo,
                title: "Favour #2: a corner of your phone",
                message: "Your tasks get saved right here on this device, not on some server where they'd gossip about your to-do list. iOS doesn't even make me ask for this one, so think of it as a polite knock."
            )

        case .done:
            pageLayout(
                symbol: "party.popper.fill",
                tint: .green,
                title: "You're all set, \(displayName)!",
                message: "Go forth and tick things off. I'll be here, quietly judging the weather."
            )
        }
    }

    @ViewBuilder
    private var locationStatusNote: some View {
        if location.isGranted {
            note("Locked in, \(displayName)! I can see the sky now.")
        } else if location.isDenied {
            VStack(spacing: 10) {
                note("No worries. I'll show a default city until you change your mind.")

                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.subheadline.weight(.semibold))
            }
        }
    }

    private func note(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }

    // MARK: - Page Layout

    private func pageLayout<Extra: View>(
        symbol: String,
        tint: Color,
        title: String,
        message: String,
        @ViewBuilder extra: () -> Extra = { EmptyView() }
    ) -> some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)

            Image(systemName: symbol)
                .font(.system(size: 52))
                .foregroundStyle(tint)
                .frame(width: 104, height: 104)
                .background(Circle().fill(tint.opacity(0.15)))

            Text(title)
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            extra()

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Actions

    private var actions: some View {
        VStack(spacing: 12) {
            Button(action: primaryAction) {
                Text(primaryTitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(step == .name && trimmedName.isEmpty)

            if step == .location && !location.isDetermined {
                Button("Maybe later") { advance() }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button(action: goBack) {
                Text("Back")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .foregroundStyle(.secondary)
            .opacity(step == .welcome ? 0 : 1)
            .disabled(step == .welcome)
        }
    }

    private var primaryTitle: String {
        switch step {
        case .welcome: return "Let's do this"
        case .name: return "Nice to meet you"
        case .location: return location.isDetermined ? "Continue" : "Allow location"
        case .storage: return "Sounds good"
        case .done: return "Show me my day"
        }
    }

    private func primaryAction() {
        if step == .location && !location.isDetermined {
            location.requestPermission()
            return
        }

        if step == .done {
            userName = trimmedName
            hasCompletedOnboarding = true
            return
        }

        advance()
    }

    // MARK: - Navigation

    private func go(to newStep: Step) {
        // Can't move past the name page without a name.
        if newStep.rawValue > Step.name.rawValue && trimmedName.isEmpty {
            return
        }

        nameFocused = false

        withAnimation(.easeInOut(duration: 0.25)) {
            step = newStep
        }
    }

    private func advance() {
        guard let next = Step(rawValue: step.rawValue + 1) else { return }
        go(to: next)
    }

    private func goBack() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        go(to: previous)
    }
}

#Preview {
    OnboardingView()
        .environment(LocationService())
}
