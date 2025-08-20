//
//  PopoverToggleView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct PopoverToggleView: View {
    @Binding var selectedTab: TabType
    let onTabSelected: (TabType) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 29)
                .fill(Color.white.opacity(0.04))
                .stroke(Color.white.opacity(0.55))
                .frame(width: 159, height: 32)
            
            RoundedRectangle(cornerRadius: 29)
                .fill(Color("Lavender-500").opacity(0.5))
                .frame(width: 70, height: 26)
                .offset(x: selectedTab == .recommended ? -39 : 39)
                .shadow(color: Color.black.opacity(0.25), radius: 7, x: 0, y: 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)

            HStack {
                Button {
                    onTabSelected(.recommended)
                } label: {
                    Text("맞춤 추천")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .textStyle(GSFont.SemiBold12)
                        .foregroundStyle(Color.white)
                        .contentShape(Rectangle())
                }
                .frame(width: 70, height: 26)
                .buttonStyle(.plain)
                
                Button {
                    onTabSelected(.personal)
                } label: {
                    Text("직접 설정")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .textStyle(GSFont.SemiBold12)
                        .foregroundStyle(Color.white)
                        .contentShape(Rectangle())
                }
                .frame(width: 70, height: 26)
                .buttonStyle(.plain)
            }
        }
    }
}
