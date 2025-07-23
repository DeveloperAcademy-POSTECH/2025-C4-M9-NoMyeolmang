//
//  TimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

// .frame(width: 800, height: 600)
// 가운데 반응형으로 바꾸기
struct TimerSettingView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        content
            .environment(\.backgroundImageName, "SpaceshipBackground")
    }

    private var content: some View {
        ZStack {
            
            Image("SpaceshipBackground")
                .frame(width: 800, height: 600)
            
            CustomBlurView(blurRadius: 10, cornerRadius: 0)
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.04))
                        .frame(width: 235, height: 40)
                    
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.white.opacity(0.55), lineWidth: 1)
                        .frame(width: 235, height: 40)
                }
                .padding(.top, 95)
                
                ZStack {
                    // 사각형 수정해야함, 색상 약간 있음
                    ZStack {
                        Color.white.opacity(0.14)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        CustomBlurView(blurRadius: 10, cornerRadius: 10)
                    }
                    .frame(width: 329, height: 161)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        .frame(width: 329, height: 161)
                    
                    VStack {
                        Text("반복 학습에 적합한 시간")
                            .textStyle(GSFont.Regular16)
                            .foregroundColor(.white)
                            .padding(.top, 34)
                        
                        Text("30분") // 시간 받아와야함
                            .textStyle(GSFont.SemiBold24)
                            .foregroundColor(.white)
                            .padding(.top, 34)
                    }                    
                }
                .padding(.top, 24)
                
                ZStack {
                    CustomBlurView(blurRadius: 10, cornerRadius: 10)
                        .frame(width: 250, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Color.white.opacity(0.14)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 250, height: 44)

                    GSButton(title: "집중 시작하기", width: 250) {
                        coordinator.push(.timer) // ⚠️ 임시값: 이후 저장된 목표시간 값으로 수정 필요 (도딘의 메모)
                    }
                }
            }
            .padding(.top, 39)
            .padding(.bottom, 197)
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerSettingView()
}
