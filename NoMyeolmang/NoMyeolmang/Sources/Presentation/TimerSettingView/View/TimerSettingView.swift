//
//  TimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerSettingView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: TimerSettingViewModel
    
    var backgroundView: some View {
        ZStack {
            Image("SpaceshipBackground")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }
    
    var body: some View {
        
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                ToggleTabView(
                    viewModel: viewModel,
                    isRecommendedSelected: $viewModel.selectedTab,
                    goalTime: $viewModel.goalTime
                )
                
                Group {
                    if viewModel.selectedTab == .recommended {
                        FocusTimeSetting(goalTime: $viewModel.goalTime)
                    } else {
                        PersonalTimerSettingView(goalTime: $viewModel.goalTime)
                    }
                }
                .frame(width: 329)
                .padding(.top, 24)
                
                ZStack {
                    GSButton(title: "집중 시작하기", width: 250, action: {
                        viewModel.startFocusSession()
                        coordinator.push(.timer)
                    }, isDisabled: !viewModel.isValid)
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
