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
        }
        .frame(minWidth: 800, minHeight: 600)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerSettingView()
}
