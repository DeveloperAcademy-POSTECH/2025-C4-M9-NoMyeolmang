//
//  PopoverReportTimeView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverReportTimeView: View {
    let goalTime: Int
    let focusTime: String
    
    var body: some View {
        VStack {
            VStack {
                Text("\(goalTime)분간 몰입해서")
                Text("탐사한 시간만 담았어요")
            }
            .foregroundStyle(Color.white)
            .textStyle(GSFont.SemiBold14)
            .padding(.bottom, 25)
        
            VStack {
                Text("탐사 시간")
                    .textStyle(GSFont.Light12)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 4)
                
                Text(focusTime)
                    .foregroundStyle(Color.white)
                    .textStyle(GSFont.SemiBold24)
            }
        }
    }
}

#Preview {
    PopoverReportTimeView(goalTime: 30, focusTime: "09:28")
}
