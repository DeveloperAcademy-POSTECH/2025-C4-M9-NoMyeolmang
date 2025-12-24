//
//  OnboardingContainerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    let popupStep: Int
    
    var body: some View {
        ZStack {
            Image("spaceship_background")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .opacity(1.0)
                .zIndex(0)
            
            if popupStep == 3 || popupStep == 4 {
                Color("Gray-900")
                    .opacity(0.55)
                    .ignoresSafeArea()
                    .zIndex(1)
            }
        }
    }
}

//#Preview("popupStep 2, 기본 배경") {
//    OnboardingContainerView(popupStep: 2)
//}
//
//#Preview("popupStep 3, 배경 흐림") {
//    OnboardingContainerView(popupStep: 3)
//}
