//
//  ReportView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//


import SwiftUI

struct ReportView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: ReportViewModel

    var body: some View {
        ZStack {
            Image("backgroundSpace")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .frame(width: 800, height: 600, alignment: .center)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.14))
                .frame(width: 600, height: 400)
            
            VStack {
                Text("이번 여정에서 총 \(viewModel.reachedDistance)km를 탐사했어요")
                    .textStyle(GSFont.SemiBold20)
                    .foregroundColor(.white)
                    .padding(.top, 34)
                Text("완전 몰입 시 도달할 수 있는 \(viewModel.maxDistance)km 중 \(viewModel.reachedRatio)%까지 도달했어요")
                    .textStyle(GSFont.Regular16)
                    .foregroundColor(.white)
                    .padding(.top,1)

                TimerReportBox(earthTime: viewModel.earthTime, focusTime: viewModel.focusTime)
                
                
                GSButton(title: "다시 시작하기", width: 250) {
                    coordinator.push(.timer)
                }
                .padding(.top, 52)
                
                GSButton(title: "종료하기", width: 250) {
                    coordinator.popToRoot()
                }
                .padding(.bottom, 25)
            } // vstack
        } // zstack
		.onAppear {
            viewModel.calDistanceTime()
        }
    } // body
}
