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
    @State private var isSpaceshipOut: Bool = false // 우주선 애니메이션 상태 관리
    @State private var isTimerOut: Bool = false // 텍스트 + 타이머 + 버튼 애니메이션 상태 관리

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                TimerBackgroundView(
                    animationDuration: viewModel.backgroundDuration, sessionState: $viewModel.sessionState
                )

                SpaceshipView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(y: isSpaceshipOut ? -geo.size.height : 0) // isSpaceshipOut일 때 우주선 위로 사라짐

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
                .opacity(isTimerOut ? 0 : 1) // isTimerOut일 때 타이머 + 버튼 fade out
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.sessionState, perform: handleSessionStateChange)
        .onAppear {
            viewModel.sessionState = .isReady
            handleAppear()
        }
        .onDisappear(perform: handleDisappear)
    }

    private func handleSessionStateChange(_ new: TimerViewState?) {
        guard let new else { return }
        
        if new == .isCompleted {
            withAnimation(.easeInOut(duration: 0.5)) { // 타이머 종료시 fade out 적용 효과
                isTimerOut = true
            } completion: { // 타이머 사라지고 우주선 애니메이션 시작
                withAnimation(.easeInOut(duration: 1)) {
                    isSpaceshipOut = true
                } completion: { // 우주선 애니메이션 끝나면 피드백 뷰로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        coordinator.push(.feedback)
                    }
                }
            }
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
