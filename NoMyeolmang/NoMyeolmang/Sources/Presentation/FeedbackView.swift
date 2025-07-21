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
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    ZStack {
                        BlurView(material: .hudWindow)
                            .frame(width: 600, height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 600, height: 400)
                        
                        VStack {
                            Spacer()
                            Button("탐사시간 확인하러 가기") {
                                coordinator.push(.report)
                            }
                            .padding(.bottom, 24)
                            .foregroundColor(.white)
                        }
                        .frame(width: 600, height: 400)
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .padding(100)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FeedbackView()
}
