//
//  TimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerSettingView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var isRecommendedSelected = true
    @State private var popupStep: Int = 0
    let popupData: [(String, String)] = [
        ("끊기지 않는 학습 리듬을 위해", "눈 깜빡임, 하품 같은 몸의 반응을 분석해\n몰입 상태를 실시간으로 알려드려요.\n집중력이 떨어지는 순간, 다시 몰입을 도와드릴게요."),
        ("영상은 저장되지 않아요", "얼굴을 촬영하거나 영상을 저장하지 않아요.\n모든 분석은 기기 내에서만 이루어지며.\n오직 집중을 돕기 위해서 사용해요."),
        ("나만의 집중 리듬을 찾아요", "공부가 끝난 뒤 집중도를 체크하는\n간단한 확인을 거쳐\n당신에게 딱 맞는 몰입 시간을 추천해드려요.")
    ]
    
    var body: some View {
        let boxSize = CGSize(width: 329, height: 161)
        
        ZStack {
            Image("SpaceshipBackground")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .frame(width: 800, height: 600, alignment: .center)
            
            VStack(spacing: 0) {
                ToggleTabView(isRecommendedSelected: $isRecommendedSelected)
                
                VStack(spacing: 0) {
                    Text("반복 학습에 적합한 시간")
                        .textStyle(GSFont.Regular16)
                        .foregroundColor(.white)
                        .padding(.top, 52.5)
                    
                    Text("30분") // 시간 받아와야함
                        .textStyle(GSFont.SemiBold24)
                        .foregroundColor(.white)
                }
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
                .padding(.top, 24)
                
                ZStack {
                    Color.white.opacity(0.14)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 250, height: 44)
                    
                    GSButton(title: "집중 시작하기", width: 250) {
                        coordinator.push(.timer)
                    }
                }
                .padding(.top, 39)
            }
            .padding(.top, 95)
            .padding(.bottom, 200)
            
            if popupStep < popupData.count {
                PopupGuideView(
                    message: popupData[popupStep].0,
                    notice: popupData[popupStep].1,
                    onNext: { popupStep += 1 }
                )
            } else if popupStep == popupData.count {
                ZStack {
                    Color("252525")
                        .opacity(0.8)
                        .ignoresSafeArea()

                    GuidanceTooltipView(
                        total: 2,
                        onConfirm: { popupStep += 1 }
                    )
                    .padding(.top, 300)
                }
            } else if popupStep == popupData.count + 1 {
                ZStack {
                    Color("252525")
                        .opacity(0.8)
                        .ignoresSafeArea()

                    GuidanceTooltipView(
                        total: 2,
                        onConfirm: { popupStep += 1 }
                    )
                    .padding(.top, 300)
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerSettingView()
}
