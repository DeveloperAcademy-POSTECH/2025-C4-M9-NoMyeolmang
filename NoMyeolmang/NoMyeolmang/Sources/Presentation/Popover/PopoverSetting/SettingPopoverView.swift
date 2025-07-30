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

    @State private var selectedTab: TabType = .recommended
    @State private var goalTime: Int = 30

    var body: some View {
        VStack {
            PopoverToggleView(
                selectedTab: $selectedTab,
                onTabSelected: { tab in
                    selectedTab = tab
                    goalTime = (tab == .recommended) ? 30 : 0
                }
            )
            .padding(.top, 16)
            .padding(.bottom, 57)

            PopoverTimerSettingView(
                selectedTab: selectedTab,
                goalTime: $goalTime
            )
            .padding(.bottom, 65)

            Button {
                // 팝오버에서 입력한 값만 viewModel에 반영
                viewModel.selectTab(selectedTab)
                viewModel.goalTime = goalTime
                viewModel.startFocusSession()
                coordinator.push(.timer)
            } label: {
                Text("다음으로")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
            .padding(.bottom, 20)
        }
        .modifier(PopoverBgModifier())
        .onAppear {
            viewModel.clear()
        }
    }
}
