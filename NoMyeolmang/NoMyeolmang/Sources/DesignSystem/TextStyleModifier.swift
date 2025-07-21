//
//  TextStyleModifier.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/21/25.
//

import SwiftUI

struct TextStyleModifier: ViewModifier {
    let font: Font
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        content
            .font(font)
            .tracking(fontSize * -0.02)      // -2% 자간
            .lineSpacing(fontSize * 0.4)     // 140% 행간
    }
}

extension View {
    func textStyle(_ font: Font, size: CGFloat) -> some View {
        self.modifier(TextStyleModifier(font: font, fontSize: size))
    }
}
