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
        VStack {
            Spacer()
            PopoverTimeLeftView(remainingTime: viewModel.formattedTime)
            PopoverTimerStopButton {
                viewModel.stopSession()
                coordinator.replaceLast(with: .timerSetting)
            }
            .padding(.top, 60)
            .padding(.bottom, 20)
        }
        .modifier(PopoverBgModifier())
    }
}
