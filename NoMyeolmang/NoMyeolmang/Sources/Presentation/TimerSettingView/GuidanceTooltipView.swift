//
//  GuidanceTooltipView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/24/25.
//

import SwiftUI

struct GuidanceTooltipView: View {
    let step: Int
    let total: Int
    let onConfirm: () -> Void

    var body: some View {
        let currentImage = step == 1 ? "tooltipBubble1" : "tooltipBubble2"

        ZStack(alignment: .topLeading) {
            Image(currentImage)
                .resizable()
                .frame(width: 196, height: step == 1 ? 83 : 101)

            VStack(alignment: .leading, spacing: 0) {
                Text(step == 1
                     ? "학습을 진행하는 해당 시간동안\n집중력이 실시간으로 측정됩니다."
                     : "탐사 시작 시, 집중 정도에 따라서\n변하는 탐사 속도를 통해 집중력을 확인할 수 있습니다.")
                    .textStyle(GSFont.Regular12)
                    .foregroundColor(Color("232323"))
                    .padding(.top, 14)

                HStack(spacing: 0) {
                    Button(action: {
                        onConfirm()
                    }) {
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
        .frame(width: 196, height: step == 1 ? 83 : 101)
    }
}

// #Preview("안내") {
//    ZStack {
//        Color.black.ignoresSafeArea()
//        GuidanceTooltipView(
//            total: 2,
//            onConfirm: {}
//        )
//    }
// }
