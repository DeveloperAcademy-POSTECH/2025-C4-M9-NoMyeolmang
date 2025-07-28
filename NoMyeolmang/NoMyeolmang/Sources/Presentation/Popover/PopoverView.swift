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
    
    var body: some View {
        VStack(spacing: 20) {
            SettingPopoverView(onStart: onStart, onStop: onStop)
        }
        .frame(width: 230, height: 270)
    }
}
