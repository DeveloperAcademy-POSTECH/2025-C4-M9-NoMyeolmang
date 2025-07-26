//
//  TimerSettingViewContentOnly.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI

struct TimerSettingViewContentOnly: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Binding var isRecommendedSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            ToggleTabView(isRecommendedSelected: $isRecommendedSelected)

            FocusTimeSetting()
                .frame(width: 329)
                .padding(.top, 24)

            ZStack {
                GSButton(title: "집중 시작하기", width: 250) {
                    coordinator.push(.timer)
                }
            }
            .padding(.top, 39)
        }
        .padding(.top, 95)
        .padding(.bottom, 200)
    }
}

#Preview {
    TimerSettingViewContentOnly(isRecommendedSelected: .constant(true))
        .environmentObject(AppCoordinator())
}
