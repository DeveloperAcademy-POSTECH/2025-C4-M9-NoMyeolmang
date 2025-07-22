//
//  FeedbackView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

// 멘트 수정해야함
func hoverDescription(for number: Int) -> String {
    switch number {
    case 1: return "전혀 몰입하지 않았어요"
    case 2: return "조금 산만했어요"
    case 3: return "보통이에요"
    case 4: return "꽤 집중했어요"
    case 5: return "완전히 몰입했어요"
    default: return ""
    }
}

struct FeedbackView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var hoveredIndex: Int? = nil
    
    var body: some View {
        ZStack {
            Image("backgroundSpace")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("planet")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .offset(y: 143) // 상대 위치로 조정
            
//            BlurView(material: .hudWindow)
//                .frame(width: 600, height: 400)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.14))
                .frame(width: 600, height: 400)
            
            VStack {
                Text("얼마나 몰입했는지 알려주세요")
                    .font(GSFont.SemiBold18)
                    .foregroundColor(.white)
                    .padding(.top, 34)
                
                Text("입력해주신 값은 집중력을 더 정확하게\n파악하기 위해서 쓰여요.")
                    .font(GSFont.Regular14)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                
                HStack(spacing: 35) {
                    ForEach(1...5, id: \.self) { number in
                        ZStack {
                            Circle()
                                .fill(Color("5C436D").opacity(0.4))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1.2)
                                )
                                .frame(width: 54, height: 54)
                                .overlay(
                                    Text("\(number)")
                                        .font(GSFont.ExtraBold20)
                                        .foregroundColor(.white)
                                )
                                .onHover { hovering in
                                    hoveredIndex = hovering ? number : nil
                                }

                            if hoveredIndex == number {
                                Text(hoverDescription(for: number))
                                    .font(GSFont.Regular12)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .fixedSize()
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color("1C1C1ED9").opacity(0.85))
                                    .cornerRadius(6)
                                    .offset(y: -50)
                            }
                        }
                        .frame(width: 54, height: 54)
                    }
                }
                .padding(.top, 51)
                
                Spacer()
                
                GSButton(title: "탐사시간 확인하러 가기", width: 250) {
                    coordinator.push(.report)
                }
                .padding(.bottom, 51)
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
