//
//  HoverRatingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/22/25.
//

import SwiftUI

// 멘트 수정해야함
private func hoverDescription(for number: Int) -> String {
    switch number {
    case 1: return "전혀 몰입하지 않았어요"
    case 2: return "조금 산만했어요"
    case 3: return "보통이에요"
    case 4: return "꽤 집중했어요"
    case 5: return "완전히 몰입했어요"
    default: return ""
    }
}

struct HoverRatingView: View {
    @Binding var selectedIndex: Int?
    @Binding var hoveredIndex: Int?
    var isSelectionValid: Bool

    var body: some View {
        HStack(spacing: 35) {
            ForEach(1...5, id: \.self) { number in
                ZStack {
                    Circle()
                        .fill(selectedIndex == number ? Color("ReportViewSelectedColor") : Color("5C436D").opacity(0.4))
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1.2)
                        )
                        .frame(width: 54, height: 54)
                        .overlay(
                            Text("\(number)")
                                .textStyle(GSFont.ExtraBold20)
                                .foregroundColor(.white)
                        )
                        .onHover { hovering in
                            hoveredIndex = hovering ? number : nil
                        }
                        .onTapGesture {
                            selectedIndex = number
                        }

                    if hoveredIndex == number {
                        Text(hoverDescription(for: number))
                            .textStyle(GSFont.Regular12)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .fixedSize()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color("1C1C1ED9").opacity(0.85))
                            .cornerRadius(6)
                            .offset(y: -50)
                    }
                }
                .frame(width: 54, height: 54)
            }
        }
    }
}

#Preview {
    HoverRatingView(selectedIndex: .constant(nil), hoveredIndex: .constant(nil), isSelectionValid: false)
}
