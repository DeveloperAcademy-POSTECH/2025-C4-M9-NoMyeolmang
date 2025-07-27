//
//  TimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerSettingView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var isRecommendedSelected = true
    
    var backgroundView: some View {
        ZStack {
            Image("SpaceshipBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }
    
    var body: some View {
        
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                ToggleTabView(isRecommendedSelected: $isRecommendedSelected)
                
                Group {
                    if isRecommendedSelected {
                        FocusTimeSetting()
                    } else {
                        PersonalTimerSettingView()
                    }
                }
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
        .frame(minWidth: 800, minHeight: 600)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerSettingView()
}
