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
        ZStack {
            SpaceshipView()
            VStack {
                VStack {
                    Text("남은 시간")
                        .textStyle(GSFont.Regular16)
                        .foregroundStyle(Color.white)
                    Text(
                        String(
                            format: "%02d : %02d",
                            viewModel.remainingTime / 60,
                            viewModel.remainingTime % 60
                        )
                    )
                    .foregroundStyle(Color.white)
                    .font(.custom("SpoqaHanSansNeo-Bold", size: 52))
                    .tracking(-3)
                }
                .padding(.top, 4)

                Button {
                    viewModel.stop()
                    coordinator.push(.timerSetting)
                } label: {
                    Image("timerstop")
                }
                .buttonStyle(.plain)
                .navigationBarBackButtonHidden()
                
                Button("Next: Feedback") {
                    coordinator.push(.feedback)
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .padding()
        .frame(width: 800, height: 600)
    }
}

#Preview {
    TimerView()
}
