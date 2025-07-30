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
                        coordinator.pop()
                    }
                    Button("Next: Feedback") {
                        viewModel.handleTimerFinished()
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.sessionState, perform: handleSessionStateChange)
        .onReceive(coordinator.$path) { path in
            // 최상단이 Timer라면 (필요한 조건으로 조정)
            if let top = path.last, top == .timer {
                guard viewModel.sessionState != .isReady else { return }
                viewModel.sessionState = .isReady
                handleAppear()
            }
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
