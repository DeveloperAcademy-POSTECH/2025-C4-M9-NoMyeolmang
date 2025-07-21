//
//  FeedbackView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Image("backgroundSpace")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

                    BlurView(material: .hudWindow)
                        .frame(width: 600, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.01))
                        .frame(width: 600, height: 400)
                    
                    VStack {
                        Text("얼마나 몰입했는지 알려주세요")
                            .font(GSFont.SemiBold18)
                            .foregroundColor(.white)
                        
                        Text("입력해주신 값은 집중력을 더 정확하게\n파악하기 위해서 쓰여요.")
                            .font(GSFont.Regular14)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 35) {
                            ForEach(1...5, id: \.self) { number in
                                Circle()
                                    .fill(Color("5C436D").opacity(0.4)) // 색 안먹음
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1.2)
                                    )
                                    .frame(width: 54, height: 54)
                                    .overlay(
                                        Text("\(number)")
                                            .font(GSFont.ExtraBold36)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .padding(.top, 24)
                        
                        Spacer()
                        GSButton(title: "탐사시간 확인하러 가기", width: 250) {
                            coordinator.push(.report)
                        }
                        .padding(.bottom, 51)
                        .foregroundColor(.white)
                    }
                    .frame(width: 600, height: 400)
            
                
            .padding(100)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FeedbackView()
}
