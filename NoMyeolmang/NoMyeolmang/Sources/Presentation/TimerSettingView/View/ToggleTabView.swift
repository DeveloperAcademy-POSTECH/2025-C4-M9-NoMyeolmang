//
//  ToggleTabView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/23/25.
//

import SwiftUI

struct ToggleTabView: View {
    @Binding var isRecommendedSelected: TabType
    @Binding var goalTime: Int

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white.opacity(0.04))
                .stroke(Color.white.opacity(0.55))
                .frame(width: 235, height: 40)

            RoundedRectangle(cornerRadius: 40)
                .fill(Color("#9D86DB80").opacity(0.55))
                .frame(width: 110, height: 32)
                .offset(x: isRecommendedSelected == .recommended ? 5 : 120)
                .shadow(color: Color.black.opacity(0.25), radius: 7, x: 0, y: 0)
                .allowsHitTesting(false)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isRecommendedSelected)

            HStack {
                Spacer().frame(width: 5)

                Text("맞춤 추천")
                    .textStyle(GSFont.SemiBold14)
                    .foregroundColor(.white)
                    .frame(width: 110, height: 32)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isRecommendedSelected = .recommended
                            goalTime = 30
                        }
                    }

                Spacer().frame(width: 5)

                Text("직접 설정")
                    .textStyle(GSFont.SemiBold14)
                    .foregroundColor(.white)
                    .frame(width: 110, height: 32)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isRecommendedSelected = .personal
                        }
                    }

                Spacer().frame(width: 5)
            }
            .frame(width: 235, height: 40)
        }
        .frame(width: 235, height: 40)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    struct ToggleTabPreviewWrapper: View {
        @State private var selectedTab: TabType = .recommended
        @State private var goalTime = 30

        var body: some View {
            ToggleTabView(isRecommendedSelected: $selectedTab, goalTime: $goalTime)
                .padding()
                .background(Color.black)
        }
    }

    return ToggleTabPreviewWrapper()
}
