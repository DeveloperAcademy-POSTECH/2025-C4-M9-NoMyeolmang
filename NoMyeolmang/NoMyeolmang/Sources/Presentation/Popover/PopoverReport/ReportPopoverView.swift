//
//  ReportPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct ReportPopoverView: View {
    var body: some View {
        VStack {
            PopoverReportTimeView()
                .padding(.bottom, 42)
            
            VStack {
                Button {
                    print("다시 시작하기 버튼 눌림!")
                } label: {
                    Text("다시 시작하기")
                        .modifier(PopoverButtonModifier())
                }
                .buttonStyle(.plain)
                
                Button {
                    print("탐사 종료하기 버튼 눌림!")
                } label: {
                    Text("탐사 종료하기")
                        .modifier(PopoverButtonModifier())
                }
                .buttonStyle(.plain)
            }
        }
        .modifier(PopoverBgModifier())
    }
}

#Preview {
    ReportPopoverView()
}
