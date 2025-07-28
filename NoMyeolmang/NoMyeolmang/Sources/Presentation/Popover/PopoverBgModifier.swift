//
//  PopoverBgModifier.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverBgModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 230, height: 270)
            .background(Color("1B0F36"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            .shadow(color: .black.opacity(0.18), radius: 15, x: 0, y: 8)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        .blur(radius: 2)
                        .offset(y: 0.5)
                        .mask(RoundedRectangle(cornerRadius: 10))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                        .mask(RoundedRectangle(cornerRadius: 10))
                }
            )
    }
}

