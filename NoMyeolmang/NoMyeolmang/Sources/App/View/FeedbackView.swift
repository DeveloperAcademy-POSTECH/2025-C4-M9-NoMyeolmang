//
//  FeedbackView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            Text("📝 Feedback")
                .font(.largeTitle)

            Button("Next: Report") {
                coordinator.push(.report)
            }
        }
    }
}
