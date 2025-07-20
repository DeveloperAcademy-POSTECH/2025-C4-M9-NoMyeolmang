//
//  RootView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var coordinator = NavigationCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
           NoticeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .notice:
                        NoticeView()
                    case .start:
                        StartView()
                    // case .timerSetting:
                       // TimerSettingView() // 뷰 만들고 나서 주석 제거해주세요
                    case .timer:
                        TimerView()
                    // case .feedback:
                       // FeedbackView()
                    case .report:
                       ReportView()
                    }
                }
        }
        .environmentObject(coordinator)
    }
}
