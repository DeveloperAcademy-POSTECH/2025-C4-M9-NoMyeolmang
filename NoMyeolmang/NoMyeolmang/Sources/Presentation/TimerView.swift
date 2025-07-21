//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        VStack {
            Text("Timer")
                .font(.largeTitle)
            VStack(spacing: 8) {
                Text("Focus Level 설정하기")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                VStack {
                    Text("실제 타이머")
                    Text(
                        String(
                            format: "%02d:%02d",
                            viewModel.remainingTime / 60,
                            viewModel.remainingTime % 60
                        )
                    )
                    .font(.title)
                }
                VStack {
                    Text("집중 타이머")
                    Text(
                        String(
                            format: "%02d:%02d",
                            viewModel.focusCount / 60,
                            viewModel.focusCount % 60
                        )
                    )
                    .font(.title)
                }
            }
            .padding(.top, 4)

            Button("예측하기") {
                viewModel.predict()
            }
            
            Button("STOP") {
                viewModel.stop()
            }
            
            Button("Next: Feedback") {
                coordinator.push(.feedback)
            }
            .navigationBarBackButtonHidden(true)
        }
        .padding()
    }
}

#Preview {
    TimerView()
}
