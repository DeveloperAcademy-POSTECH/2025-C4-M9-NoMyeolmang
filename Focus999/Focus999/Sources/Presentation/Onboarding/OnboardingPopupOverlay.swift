//
//  OnboardingPopupOverlay.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI

struct OnboardingPopupOverlay: View {
    let popupStep: Int
    let popupData: [(String, String)]
    let onAdvance: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        if popupStep < popupData.count {
            PopupGuideView(
                message: popupData[popupStep].0,
                notice: popupData[popupStep].1,
                onNext: onAdvance
            )
        } else if popupStep == popupData.count {
            GuidanceTooltipViewStep1(
                total: 2,
                onConfirm: onAdvance
            )
            .offset(x: -265, y: -50)
            .zIndex(99)
        } else if popupStep == popupData.count + 1 {
            GuidanceTooltipViewStep2(
                total: 2,
                onConfirm: onComplete
            )
            .offset(x: -225, y: 50)
            .zIndex(99)
        }
    }
}
