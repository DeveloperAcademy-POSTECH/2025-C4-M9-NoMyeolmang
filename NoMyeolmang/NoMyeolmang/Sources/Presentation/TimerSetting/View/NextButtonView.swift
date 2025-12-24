//
//  NextButtonView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/24/25.
//

import SwiftUI

struct NextButtonView: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Color.white.opacity(0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.7), lineWidth: 0.7)
                Text("다음으로")
                    .textStyle(GSFont.SemiBold14)
                    .foregroundColor(.white)
            }
            .frame(width: 182, height: 32)
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

//#Preview {
//    ZStack {
//        Color.black.ignoresSafeArea()
//        NextButtonView(onTap: {
//            print("Tapped")
//        })
//    }
//    .frame(width: 220, height: 80)
//}
