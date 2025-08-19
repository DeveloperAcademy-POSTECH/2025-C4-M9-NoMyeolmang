//
//  Button.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/21/25.
//

import SwiftUI

struct GSButton: View {
    let title: String
    let width: CGFloat
    let action: () -> Void
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(GSFont.SemiBold16)
                .foregroundColor(.white.opacity(isDisabled ? 0.7 : 1.0))
                .frame(width: width, height: 44)
                .background(
                    ZStack {
                        Color.white.opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(isDisabled ? 0.3 : 0.7), lineWidth: 1)
                    }
                )
        }
        .shadow(color: Color.black.opacity(0.0168), radius: 2.21, x: 0, y: 2.77)
        .shadow(color: Color.black.opacity(0.022), radius: 5.32, x: 0, y: 6.65)
        .shadow(color: Color.black.opacity(0.025), radius: 10.02, x: 0, y: 12.52)
        .shadow(color: Color.black.opacity(0.0273), radius: 17.87, x: 0, y: 22.34)
        .shadow(color: Color.black.opacity(0.0304), radius: 33.42, x: 0, y: 41.78)
        .shadow(color: Color.black.opacity(0.04), radius: 80, x: 0, y: 100)
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

#Preview {
    ZStack {
        Image("space_background")
            .resizable()
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white.opacity(0.14))
            .frame(width: 400, height: 300)
        
        VStack(spacing: 20) {
            GSButton(title: "집중 시작하기", width: 250) {
                print("250 버튼")
            }
            .padding()
            
            GSButton(title: "다음으로", width: 180) {
                print("180 버튼")
            }
            .padding()
        }
    }
}
