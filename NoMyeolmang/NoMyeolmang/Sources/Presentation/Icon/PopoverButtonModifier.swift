//
//  PopoverButtonModifier.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct PopoverButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .textStyle(GSFont.SemiBold14)
            .foregroundStyle(Color.white)
            .frame(width: 160, height: 30)
            .cornerRadius(4)
            .contentShape(Rectangle())
            .background(
                ZStack {
                    Color("#9D86DB80").opacity(0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                }
            )
            .shadow(color: Color.black.opacity(0.0168), radius: 2.21, x: 0, y: 2.77)
            .shadow(color: Color.black.opacity(0.022), radius: 5.32, x: 0, y: 6.65)
            .shadow(color: Color.black.opacity(0.025), radius: 10.02, x: 0, y: 12.52)
            .shadow(color: Color.black.opacity(0.0273), radius: 17.87, x: 0, y: 22.34)
            .shadow(color: Color.black.opacity(0.0304), radius: 33.42, x: 0, y: 41.78)
            .shadow(color: Color.black.opacity(0.04), radius: 80, x: 0, y: 100)
    }
}
