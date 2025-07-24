//
//  GuidanceTooltipView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/24/25.
//

import SwiftUI

struct GuidanceTooltipView: View {
    let text: String
    let step: Int
    let total: Int
    let onConfirm: () -> Void
    let bubbleImageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(text)
                .textStyle(GSFont.Regular12)
                .foregroundColor(.white)

            HStack {
                Button("확인", action: onConfirm)
                    .textStyle(GSFont.SemiBold14)
                    .foregroundColor(Color("7243D4"))

                Spacer()

                Text("\(step)/\(total)")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(14)
        .background(
            Image(bubbleImageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.white.opacity(0.1))
        )
        .frame(width: 220)
    }
}

#Preview("안내 1") {
    ZStack {
        Color.black.ignoresSafeArea()
        GuidanceTooltipView(
            text: "학습을 진행하는 해당 시간동안\n집중력이 실시간으로 측정됩니다.",
            step: 1,
            total: 2,
            onConfirm: {},
            bubbleImageName: "tooltipBubble1"
        )
        .offset(x: -100, y: -80)
    }
}

#Preview("안내 2") {
    ZStack {
        Color.black.ignoresSafeArea()
        GuidanceTooltipView(
            text: "집중도는 탐사 종료 후 분석되어\n당신만의 리듬을 추천해드려요.",
            step: 2,
            total: 2,
            onConfirm: {},
            bubbleImageName: "tooltipBubble2"
        )
        .offset(x: 100, y: 80)
    }
}
