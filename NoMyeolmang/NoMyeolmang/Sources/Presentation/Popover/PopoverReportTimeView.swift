//
//  PopoverReportTimeView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverReportTimeView: View {
    var body: some View {
        VStack {
            Text("지구 시간")
                .textStyle(GSFont.Light12)
                .foregroundStyle(Color.white)
                .padding(.bottom, 4)
            
            Text("00:00")
                .foregroundStyle(Color.white)
                .textStyle(GSFont.SemiBold24)
            
            Text("탐사 시간")
                .textStyle(GSFont.Light12)
                .foregroundStyle(Color.white)
                .padding(.bottom, 4)
            
            Text("00:00")
                .foregroundStyle(Color.white)
                .textStyle(GSFont.SemiBold24)
        }
    }
}

#Preview {
    PopoverReportTimeView()
}
