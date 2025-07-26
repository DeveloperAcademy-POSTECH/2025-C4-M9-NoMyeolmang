//
//  ReportView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var viewModel = ReportViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Report")
                .font(.largeTitle)
            
            Text("이번 여정에서 총 \(viewModel.reachedDistance)km를 탐사했어요")
            
            Text("완전 몰입 시 도달할 수 있는 \(viewModel.maxDistance)km중 \(viewModel.reachedRatio)%까지 도달했어요.")
            
            HStack {
                VStack {
                    Text("지구 시간")
                    Text(viewModel.earthTime)
                }
                
                VStack {
                    Text("탐사 시간")
                    Text(viewModel.focusTime)
                }
            }

            Button("다시 시작") {
                coordinator.push(.timer) // ⚠️ 임시값: 이후 저장된 목표시간 값으로 수정 필요
            }
            .navigationBarBackButtonHidden(true)

            Button("탐사 종료") {
                coordinator.popToRoot()  // TimerSettingView로
            }
            .navigationBarBackButtonHidden(true)
        }
        .padding()
        .onAppear {
            viewModel.calDistanceTime()
        }
    }
}

#Preview {
    ReportView()
}
