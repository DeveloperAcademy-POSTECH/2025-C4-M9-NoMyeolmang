//
//  NoticeView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct NoticeView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Notice View")
                .font(.largeTitle)

            Button("시작하기") {
                coordinator.push(.start)
            }
        }
    }
}

#Preview {
    NoticeView()
        .environmentObject(NavigationCoordinator())
}
