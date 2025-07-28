//
//  FeedbackPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct FeedbackPopoverView: View {
    @ObservedObject var viewModel: FeedbackViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("얼마나 몰입했는지 알려주세요")
                    .textStyle(GSFont.SemiBold14)
                    .foregroundStyle(Color.white)
                
                VStack {
                    Text("입력해주신 값은 집중력을 더 정확하게")
                    Text("파악하기 위해서 쓰여요.")
                }
                .foregroundStyle(Color.white)
                .font(.custom("Pretendard-Regular", size: 10))
                .padding(.top, 4)
            }
            .padding(.top, 38)
            
            PopoverRatingButton(selectedIndex: $viewModel.selectedIndex,
                                hoveredIndex: $viewModel.hoveredIndex)
            .padding(.top, 38)

            Button {
                print("완료 버튼 눌림! 🥹")
            } label: {
                Text("완료")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
            .padding(.bottom, 20)
            .padding(.top, 65)
        }
        .frame(width: 230, height: 270)
        .background(
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 230, height: 270)
            .background(Color(red: 0.89, green: 0.89, blue: 0.89).opacity(0.35))

            .background(.white.opacity(0))

            .cornerRadius(10)
            .shadow(color: .black.opacity(0.18), radius: 7.5, x: 0, y: 8)

            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
            .overlay(
            RoundedRectangle(cornerRadius: 10)
            .inset(by: -0.25)
            .stroke(.black.opacity(0.06), lineWidth: 0.5)
            )
            .blur(radius: 40.77423)
        )
    }
}
