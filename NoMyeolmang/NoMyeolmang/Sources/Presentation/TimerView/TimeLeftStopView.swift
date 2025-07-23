//
//  TimeLeftView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/23/25.
//

import SwiftUI

struct TimeLeftStopView: View {
    @StateObject private var viewModel = TimerViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
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
            
            Button {
                viewModel.stop()
                coordinator.push(.timerSetting)
            } label: {
                Image("timerstop")
            }
            .buttonStyle(.plain)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    TimeLeftStopView()
}
