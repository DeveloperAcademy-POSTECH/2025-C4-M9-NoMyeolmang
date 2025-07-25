//
//  PopoverView..swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/25/25.
//

import SwiftUI

struct PopoverView: View {
    var onStart: () -> Void
    var onStop: () -> Void
    @State private var isStopped = false

    var body: some View {
        VStack(spacing: 20) {
            if isStopped {
                Text("타이머가 멈췄을 때의 뷰를 보여줄 수 있음")
                    .textStyle(GSFont.SemiBold18)
            } else {
                Text("🌠🎸")
                    .textStyle(GSFont.SemiBold18)
                Button("시작하기") {
                    onStart()
                }
                Button("멈추기") {
                    isStopped = true
                    onStop()
                }
            }
        }
        .frame(width: 230, height: 270)
    }
}
