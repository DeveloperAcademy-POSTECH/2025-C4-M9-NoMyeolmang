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
            SettingPopoverView()
//            if isStopped {
//                Text("타이머 멈췄을 때의\n뷰는 여기")
//                    .textStyle(GSFont.SemiBold18)
//            } else {
//                Text("🌠🎸")
//                    .textStyle(GSFont.SemiBold18)
//                Button("시작하기") {
//                    onStart()
//                }
//                Button("멈추기") {
//                    isStopped = true
//                    onStop()
//                }
//            }
        }
        .frame(width: 230, height: 270)
    }
}
