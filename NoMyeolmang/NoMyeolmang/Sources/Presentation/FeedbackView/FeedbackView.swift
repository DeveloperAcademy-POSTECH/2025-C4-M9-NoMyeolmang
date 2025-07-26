//
//  FeedbackView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct FeedbackView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: FeedbackViewModel

    var body: some View {
        ZStack {
            Image("backgroundSpace")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.14))
                .frame(width: 600, height: 400)

            VStack {
                Text("얼마나 몰입했는지 알려주세요")
                    .textStyle(GSFont.SemiBold18)
                    .foregroundColor(.white)
                    .padding(.top, 34)

                Text("입력해주신 값은 집중력을 더 정확하게\n파악하기 위해서 쓰여요.")
                    .textStyle(GSFont.Regular14)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)

                HoverRatingView(viewModel: viewModel)
                    .padding(.top, 51)

                Spacer()

                GSButton(title: "탐사시간 확인하러 가기", width: 250) {
                    Task {
                        do {
                            try await viewModel.updateTrainingData()
                            try await viewModel.personalizing()
                        } catch {
                            print("실패")
                        }
                    }
                    coordinator.push(.report)
                }
                .padding(.bottom, 51)
                .disabled(viewModel.selectedIndex == nil)

                // test code
                Button("테스트 데이터 생성") {
                    Task { @MainActor in
                        try await viewModel.writeTestData()
                    }
                }
            }
            .frame(width: 600, height: 400)
            .padding(100)
        }
        .navigationBarBackButtonHidden(true)
    }
}
