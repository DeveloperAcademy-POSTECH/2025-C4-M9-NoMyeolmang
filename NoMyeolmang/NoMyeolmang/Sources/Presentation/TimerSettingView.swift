//
//  TimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerSettingView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            Text("Timer Setting")
                .font(.largeTitle)

            Button("Start Timer") {
                coordinator.push(.timer) // ⚠️ 임시값: 이후 저장된 목표시간 값으로 수정 필요
            }
            .navigationBarBackButtonHidden(true)
        }
        .padding()
    }
}

#Preview {
    TimerSettingView()
}
