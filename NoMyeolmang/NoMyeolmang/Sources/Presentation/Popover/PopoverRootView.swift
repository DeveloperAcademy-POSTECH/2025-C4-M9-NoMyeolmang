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

struct PopoverRootView: View {
    var onClick: () -> Void
    
    @State var page: PopoverPage = .setting
    
    var body: some View {
        VStack {
            switch page {
            case .setting:
                SettingPopoverView()
            case .timer:
                TimerPopoverView()
            case .feedback:
                FeedbackPopoverView()
            case .report:
                ReportPopoverView()
            }
        }
        .frame(width: 230, height: 270)
    }
}
