//
//  GuidanceTooltipView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/24/25.
//

import SwiftUI

struct GuidanceTooltipViewStep1: View {
    let total: Int
    let onConfirm: () -> Void

    var body: some View {
        let currentImage = "tooltip_bubble1"

        ZStack(alignment: .topLeading) {
            Image(currentImage)
                .resizable()
                .frame(width: 196, height: 83)

            VStack(alignment: .leading, spacing: 0) {
                Text("학습을 진행하는 해당 시간동안\n집중력이 실시간으로 측정됩니다.")
                    .textStyle(GSFont.Regular12)
                    .foregroundColor(Color("Gray-900"))
                    .padding(.top, 14)

                HStack(spacing: 0) {
                    Button(action: {
                        onConfirm()
                    }) {
                        Text("확인")
                            .textStyle(GSFont.SemiBold12)
                            .foregroundColor(Color("Violet-600"))
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text("1/\(total)")
                        .textStyle(GSFont.Regular12)
                        .foregroundColor(Color("Gray-900"))
                        .padding(.trailing, 23)
                }
                .padding(.top, 8)
            }
            .padding(.leading, 14)
        }
        .frame(width: 196, height: 83)
    }
}

struct GuidanceTooltipViewStep2: View {
    let total: Int
    let onConfirm: () -> Void

    var body: some View {
        let currentImage = "tooltip_bubble2"

        ZStack(alignment: .topLeading) {
            Image(currentImage)
                .resizable()
                .frame(width: 196, height: 101)

            VStack(alignment: .leading, spacing: 0) {
                Text("탐사 시작 시, 집중 정도에 따라서\n변하는 탐사 속도를 통해 집중력을 확인할 수 있습니다.")
                    .textStyle(GSFont.Regular12)
                    .foregroundColor(Color("Gray-900"))
                    .padding(.top, 14)

                HStack(spacing: 0) {
                    Button(action: {
                        onConfirm()
                    }) {
                        Text("확인")
                            .textStyle(GSFont.SemiBold12)
                            .foregroundColor(Color("Violet-600"))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Text("2/\(total)")
                        .textStyle(GSFont.Regular12)
                        .foregroundColor(Color("Gray-900"))
                        .padding(.trailing, 23)
                }
                .padding(.top, 8)
            }
            .padding(.leading, 14)
        }
        .frame(width: 196, height: 101)
    }
}

//#Preview("툴팁 1 & 2") {
//    VStack(spacing: 30) {
//        GuidanceTooltipViewStep1(total: 2, onConfirm: {})
//        GuidanceTooltipViewStep2(total: 2, onConfirm: {})
//    }
//    .padding()
//    .background(Color.black.opacity(0.7))
//    .ignoresSafeArea()
//}
