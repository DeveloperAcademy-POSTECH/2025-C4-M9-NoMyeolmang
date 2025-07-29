//
//  SettingPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct SettingPopoverView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: TimerSettingViewModel
    
    var body: some View {
        VStack {
            PopoverToggleView(
                selectedTab: $viewModel.selectedTab,
                onTabSelected: { tab in
                    viewModel.selectTab(tab)
                }
            )
                .padding(.top, 16)
                .padding(.bottom, 57)
            
            PopoverTimerSettingView(
                selectedTab: viewModel.selectedTab,
                goalTime: $viewModel.goalTime
            )
                .padding(.bottom, 65)

            Button {
                viewModel.startFocusSession()
                coordinator.push(.timer)
            } label: {
                Text("다음으로")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.isValid)
            .padding(.bottom, 20)
        }
        .modifier(PopoverBgModifier())
    }
}
