//
//  PopoverTimeLeftView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverTimeLeftView: View {
    let remainingTime: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text("남은 시간")
                .textStyle(GSFont.Regular14)
                .foregroundStyle(Color.white)
                .padding(.bottom, 4)
            
            Text(remainingTime)
                .foregroundStyle(Color.white)
                .textStyle(GSFont.SemiBold24)
                .tracking(-3)
        }
    }
}

//#Preview {
//    PopoverTimeLeftView(remainingTime: "05 : 30")
//}
