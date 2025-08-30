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

    @State private var selectedIndex: Int?
    @State private var hoveredIndex: Int?

    var isSelectionValid: Bool {
        selectedIndex != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("얼마나 몰입했는지 알려주세요")
                    .textStyle(GSFont.SemiBold14)
                    .foregroundStyle(Color.white)

                Text("입력해주신 값은 집중력을 더 정확하게\n파악하기 위해서 쓰여요.")
                    .fixedSize(horizontal: false, vertical: true)
                    .textStyle(GSFont.Regular12)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.top, 4)
            }
            .padding(.top, 32)

            PopoverRatingButton(
                selectedIndex: $selectedIndex,
                hoveredIndex: $hoveredIndex
            )
            .padding(.top, 38)

            Button {
                // 버튼 클릭 시에만 viewModel에 값 반영
                viewModel.selectedIndex = selectedIndex
                viewModel.hoveredIndex = hoveredIndex
                Task {
                    _ = await viewModel.updateTrainingDataAndPersonalize()
                    coordinator.push(.report)
                }
            } label: {
                Text("완료")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
            .disabled(!isSelectionValid)
            .padding(.bottom, 20)
            .padding(.top, 65)
        }
        .modifier(PopoverBgModifier())
    }
}
