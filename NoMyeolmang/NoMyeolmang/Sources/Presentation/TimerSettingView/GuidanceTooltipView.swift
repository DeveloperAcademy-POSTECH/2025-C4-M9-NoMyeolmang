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
        ZStack(alignment: .topLeading) {
            Image(bubbleImageName)
                .resizable()
                .frame(width: 196, height: bubbleImageName == "tooltipBubble2" ? 101 : 83)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(text)
                    .textStyle(GSFont.Regular12)
                    .foregroundColor(Color("232323"))
                    .padding(.top, 14)

                HStack(spacing: 0) {
                    Button(action: onConfirm) {
                        Text("확인")
                            .textStyle(GSFont.SemiBold12)
                            .foregroundColor(Color("7243D4"))
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text("\(step)/\(total)")
                        .textStyle(GSFont.Regular12)
                        .foregroundColor(Color("232323"))
                        .padding(.trailing, 23)
                }
                .padding(.top, 8)
            }
            .padding(.leading, 14)
        }
        .frame(width: 196, height: bubbleImageName == "tooltipBubble2" ? 101 : 83)
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
    }
 }

 #Preview("안내 2") {
    ZStack {
        Color.black.ignoresSafeArea()
        GuidanceTooltipView(
            text: "탐사 시작 시, 집중 정도에 따라서\n변하는 탐사 속도를 통해 집중력을 확인할 수 있습니다.",
            step: 2,
            total: 2,
            onConfirm: {},
            bubbleImageName: "tooltipBubble2"
        )
    }
 }
