//
//  RootView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    var body: some View {
        if hasSeenOnboarding {
            NavigationStack(path: $coordinator.path) {
                TimerSettingView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .timerSetting:
                            TimerSettingView()
                        case .timer:
                            TimerView()
                        case .feedback:
                            FeedbackView()
                        case .report:
                            ReportView()
                        }
                    }
            }
            .frame(minWidth: 800, minHeight: 600)
        } else {
            OnboardingView(showOnboarding: Binding(
                get: { !hasSeenOnboarding },
                set: { newValue in
                    if !newValue {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        hasSeenOnboarding = true
                    }
                }
            ))
            .frame(minWidth: 800, minHeight: 600)
        }
    }
}
