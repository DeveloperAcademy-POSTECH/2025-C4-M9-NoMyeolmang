//
//  OnboardingMainContentView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI

struct OnboardingMainContentView: View {
    let popupStep: Int
    let popupDataCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ToggleTabView(
                selectedTab: .constant(.recommended),
                onTabSelected: { _ in }
            )
            .opacity((popupStep == popupDataCount || popupStep == popupDataCount + 1) ? 0.3 : 1)
            .zIndex(popupStep == popupDataCount ? 0.6 : 0)
            FocusTimeSetting(goalTime: .constant(30))
                .frame(width: 329)
                .padding(.top, 24)
                .opacity(popupStep == popupDataCount ? 1 : 0.3)
                .zIndex(popupStep == popupDataCount ? 99 : 0)
            GSButton(title: "집중 시작하기", width: 250) {}
                .padding(.top, 39)
                .zIndex(popupStep == popupDataCount + 1 ? 99 : 0)
                .allowsHitTesting(!(popupStep == popupDataCount || popupStep == popupDataCount + 1))
                .opacity(popupStep == popupDataCount + 1 ? 1 : 0.3)
        }
        .padding(.top, 95)
        .padding(.bottom, 200)
    }
}

// #Preview("기본 상태, popupStep 0") {
//    OnboardingMainContentView(popupStep: 0, popupDataCount: 3)
// }
//
// #Preview("툴팁 1단계, FocusTimeSetting") {
//    OnboardingMainContentView(popupStep: 3, popupDataCount: 3)
// }
//
// #Preview("툴팁 2단계, 버튼 ") {
//    OnboardingMainContentView(popupStep: 4, popupDataCount: 3)
// }
