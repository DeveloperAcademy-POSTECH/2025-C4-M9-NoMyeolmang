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
    
    var body: some View {
        content
            .environment(\.backgroundImageName, "SpaceshipBackground")
    }
    
    private var content: some View {
        ZStack {
            Image("SpaceshipBackground")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fit)
                .frame(width: 800, height: 600, alignment: .center)
            
            VStack(spacing: 0) {
                ToggleTabView(isRecommendedSelected: $isRecommendedSelected)
                
                ZStack {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("939393").opacity(0.02),
                                Color("A471C8").opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .opacity(0.4)
                        //                         블러뷰 수정 후 담을 예정
                        CustomBlurView(blurRadius: 10, cornerRadius: 10)
                    }
                    .frame(width: 329, height: 161)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        .frame(width: 329, height: 161)
                    
                    VStack(spacing: 0) {
                        Text("반복 학습에 적합한 시간")
                            .textStyle(GSFont.Regular16)
                            .foregroundColor(.white)
                            .padding(.top, 52.5)
                        
                        Text("30분") // 시간 받아와야함
                            .textStyle(GSFont.SemiBold24)
                            .foregroundColor(.white)
                    }
                    .frame(width: 329, height: 161, alignment: .top)
                }
                .padding(.top, 24)
                
                ZStack {
                    
//                    CustomBlurView(blurRadius: 10, cornerRadius: 10)
//                        .frame(width: 250, height: 44)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                     // opacity
                    Color.white.opacity(0.14)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .frame(width: 250, height: 44)
                    
                    GSButton(title: "집중 시작하기", width: 250) {
                        coordinator.push(.timer) // ⚠️ 임시값: 이후 저장된 목표시간 값으로 수정 필요 (도딘의 메모)
                    }
                }
                .padding(.top, 39)
            }
            .padding(.top, 95)
            .padding(.bottom, 200)
        }
        .frame(minWidth: 800, minHeight: 600)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerSettingView()
}
