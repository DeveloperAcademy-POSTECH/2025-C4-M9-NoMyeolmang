//
//  PopoverView..swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/25/25.
//

import SwiftUI

enum PopoverPage {
    case setting
    case timer
    case feedback
    case report
}

struct PopoverView: View {
    var onStart: () -> Void
    var onStop: () -> Void
    
    @State var page: PopoverPage = .setting
    
    var body: some View {
        VStack {
            switch page {
            case .setting:
                SettingPopoverView(onStart: { page = .timer }, onStop: onStop)
            case .timer:
                TimerPopoverView(onStart: { page = .feedback }, onStop: onStop)
            case .feedback:
                FeedbackPopoverView(onStart: { page = .report }, onStop: onStop)
            case .report:
                ReportPopoverView(onStart: { page = .timer }, onStop: { page = .setting })
            }
        }
        .frame(width: 230, height: 270)
    }
}
