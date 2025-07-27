//
//  OnboardingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var popupStep: Int = 0

    let popupData: [(String, String)] = [
        ("끊기지 않는 학습 리듬을 위해", "눈 깜빡임, 하품 같은 몸의 반응을 분석해\n몰입 상태를 실시간으로 알려드려요.\n집중력이 떨어지는 순간, 다시 몰입을 도와드릴게요."),
        ("영상은 저장되지 않아요", "얼굴을 촬영하거나 영상을 저장하지 않아요.\n모든 분석은 기기 내에서만 이루어지며.\n오직 집중을 돕기 위해서 사용해요."),
        ("나만의 집중 리듬을 찾아요", "공부가 끝난 뒤 집중도를 체크하는\n간단한 확인을 거쳐\n당신에게 딱 맞는 몰입 시간을 추천해드려요.")
    ]

    var body: some View {
        ZStack {
            OnboardingContainerView(popupStep: popupStep)

            OnboardingMainContentView(
                popupStep: popupStep,
                popupDataCount: popupData.count
            )

            OnboardingPopupOverlay(
                popupStep: popupStep,
                popupData: popupData,
                onAdvance: {
                    if popupStep < popupData.count + 1 {
                        popupStep += 1
                    }
                },
                onComplete: {
                    showOnboarding = false
                }
            )
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
        .frame(width: 800, height: 600)
}
