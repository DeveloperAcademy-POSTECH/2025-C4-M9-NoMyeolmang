//
//  RootView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TimerSettingView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .timerSetting:
                        TimerSettingView()
                    case .timer(let goalTime):
                        TimerView(goalTime: goalTime)
                    case .feedback:
                        FeedbackView()
                    case .report:
                        ReportView()
                    }
                }
        }
    }
}
