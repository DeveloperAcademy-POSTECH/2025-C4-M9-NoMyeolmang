//
//  TimerPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct TimerPopoverView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            PopoverTimeLeftView(remainingTime: viewModel.formattedTime)
            PopoverTimerStopButton {
                viewModel.stopSession()
                coordinator.replaceLast(with: .timerSetting)
            }
            .padding(.top, 65)
            .padding(.bottom, 30)
        }
        .modifier(PopoverBgModifier())
    }
}
