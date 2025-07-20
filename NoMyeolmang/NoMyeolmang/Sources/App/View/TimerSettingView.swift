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
            Text("⏱ Timer Setting")
                .font(.largeTitle)

            Button("Start Timer") {
                coordinator.push(.timer)
            }
        }
    }
}
