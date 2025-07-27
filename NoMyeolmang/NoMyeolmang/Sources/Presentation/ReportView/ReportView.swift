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
        let boxSize = CGSize(width: 345, height: 119)

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

                HStack(spacing: 48){
                    VStack(spacing: 2){
                        Text("지구 시간")
                            .textStyle(GSFont.Light14)
                            .foregroundColor(.white)
                        Text(viewModel.earthTime)
                            .textStyle(GSFont.SemiBold28)
                            .foregroundColor(.white)
                        }
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 1, height: 99)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .opacity(0.1)
                    VStack(spacing: 2){
                        Text("탐사 시간")
                            .textStyle(GSFont.Light14)
                            .foregroundColor(.white)
                        Text(viewModel.focusTime)
                            .textStyle(GSFont.SemiBold28)
                            .foregroundColor(.white)
                        }
                    } // hstack
                
                .frame(width: boxSize.width, height: boxSize.height, alignment: .top)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("939393").opacity(0.02),
                            Color("A471C8").opacity(0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .opacity(0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
                .padding(.top, 25)
                
                
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
