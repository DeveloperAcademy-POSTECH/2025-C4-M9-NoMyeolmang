//
//  PopoverView..swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/25/25.
//

import SwiftUI

struct PopoverView: View {
    var onStart: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("🌠🎸")
                .textStyle(GSFont.SemiBold18)
            Button("시작하기") {
                onStart() // 타이머뷰에도 담아야함 (다른 브랜치에서 작업 예정)
            }
        }
        .frame(width: 230, height: 270)
    }
}
