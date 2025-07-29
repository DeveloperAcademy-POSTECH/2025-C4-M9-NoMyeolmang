//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                TimerBackgroundView(animationDuration: viewModel.backgroundDuration, sessionState: $viewModel.sessionState)

                SpaceshipView()
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .center, spacing: 32) {
                    TimeLeftView(remainingTimeText: viewModel.formattedTime)

                    TimerStopButton {
                        viewModel.stopSession()
                        coordinator.replaceLast(with: .timerSetting)
                    }
                    Button("Next: Feedback") {
                        viewModel.handleTimerFinished()
                        coordinator.push(.feedback)
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.sessionState, perform: handleSessionStateChange)
        .onAppear{
            viewModel.sessionState = .isReady
            handleAppear()
        }
        .onDisappear(perform: handleDisappear)
    }

    private func handleSessionStateChange(_ new: TimerViewState?) {
        guard let new else { return }
        
        if new == .isCompleted {
            coordinator.push(.feedback)
        }
    }

    private func handleAppear() {
        print("뷰모델 가동 - 세션 시작")
        viewModel.startSession()
    }

    private func handleDisappear() {
        print("뷰모델 정지 - 세션 종료")
        if viewModel.sessionState == .isRunning {
            viewModel.stopSession()
        }
    }
}
