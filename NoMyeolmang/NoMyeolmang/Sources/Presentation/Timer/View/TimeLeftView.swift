//
//  TimeLeftView.swift
//  NoMyeolmang
//
//  Created by Moo on 7/26/25.
//

import SwiftUI

struct TimeLeftView: View {
    let remainingTimeText: String

    var body: some View {
        VStack {
            Text("남은 시간")
                .textStyle(GSFont.Regular16)
                .foregroundStyle(Color.white)

            Text(remainingTimeText)
                .foregroundStyle(Color.white)
                .font(.custom("SpoqaHanSansNeo-Bold", size: 52))
                .tracking(-2)
        }
    }
}

// #Preview {
//    TimeLeftView(remainingTimeText: "05:30")
// }
