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
    @State private var showOnboarding = true
    
    var body: some View {
        
        ZStack {
            Color("252525")
                .opacity(0.55)
                .edgesIgnoringSafeArea(.all)
            
            Image("SpaceshipBackground")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
              //  .frame(width: 800, height: 600, alignment: .center)
            
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            }
            
            if !showOnboarding {
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
        .frame(minWidth: 800, minHeight: 600)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerSettingView()
}
