//
//  ReportView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Report")
                .font(.largeTitle)

            Button("다시 시작") {
                coordinator.push(.timer)
            }

            Button("탐사 종료") {
                coordinator.popToRoot() // TimerSettingView로
            }
        }
    }
}
