//
//  GSFont.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/21/25.
//

import SwiftUI

struct GSFontStyle {
    let font: Font
    let size: CGFloat
}

enum GSFont {
    
    // Pretendard-ExtraBold
    static let ExtraBold20 = GSFontStyle(font: .custom("Pretendard-ExtraBold", size: 20), size: 20)
    
    // Pretendard-SemiBold
    static let SemiBold28 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 28), size: 28)
    static let SemiBold24 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 24), size: 24)
    static let SemiBold20 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 20), size: 20)
    static let SemiBold18 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 18), size: 18)
    static let SemiBold16 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 16), size: 16)
    static let SemiBold14 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 14), size: 14)
    static let SemiBold12 = GSFontStyle(font: .custom("Pretendard-SemiBold", size: 12), size: 12)

    // Pretendard Regular
    static let Regular16 = GSFontStyle(font: .custom("Pretendard-Regular", size: 16), size: 16)
    static let Regular14 = GSFontStyle(font: .custom("Pretendard-Regular", size: 14), size: 14)
    static let Regular12 = GSFontStyle(font: .custom("Pretendard-Regular", size: 12), size: 12)

    // Pretendard Light
    static let Light16 = GSFontStyle(font: .custom("Pretendard-Light", size: 16), size: 16)
    static let Light14 = GSFontStyle(font: .custom("Pretendard-Light", size: 14), size: 14)
    static let Light12 = GSFontStyle(font: .custom("Pretendard-Light", size: 12), size: 12)

    // Spoqa Han Sans Neo
    static let spoqaBold52 = GSFontStyle(font: .custom("SpoqaHanSansNeo-Bold", size: 52), size: 52)
}
