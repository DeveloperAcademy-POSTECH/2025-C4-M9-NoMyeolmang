//
//  FeedbackPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct FeedbackPopoverView: View {
    @EnvironmentObject var coordinator: AppCoordinator
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
            
            PopoverRatingButton(
                selectedIndex: $viewModel.selectedIndex,
                hoveredIndex: $viewModel.hoveredIndex
            )
            .padding(.top, 38)

            Button {
                Task {
                    _ = await viewModel.updateTrainingDataAndPersonalize()
                    coordinator.push(.report)
                }
            } label: {
                Text("완료")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.isSelectionValid)
            .padding(.bottom, 20)
            .padding(.top, 65)
        }
        .modifier(PopoverBgModifier())
    }
}
