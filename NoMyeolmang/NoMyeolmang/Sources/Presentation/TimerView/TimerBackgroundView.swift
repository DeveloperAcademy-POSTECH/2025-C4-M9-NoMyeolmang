//
//  TimerBackgroundView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/23/25.
//

import SwiftUI

struct TimerBackgroundView: View {
    // 이미지 높이
    let imageHeight: CGFloat = 4000
    // 화면 높이 -> geometry로 받아오도록 수정하기
    @State private var screenHeight: CGFloat = 650
    // 애니메이션 진행 상태
    @State private var offsetY: CGFloat = 0
    // 타이머
    @State private var timer: Timer?
    // 최초 위치
    @State private var initialOffsetY: CGFloat = 0
        
    // 전체 애니메이션 시간 (초) -> 100% 기준속도 기록해두기
    @State private var duration: Double = 12

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Image("timerBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(height: imageHeight)
                    .offset(y: offsetY)
                    .onAppear {
                        startLoopingAnimation(screenHeight: geo.size.height)
                    }
                    .onDisappear {
                        timer?.invalidate()
                    }
            }
            .clipped()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
            
    func startLoopingAnimation(screenHeight: CGFloat) {
        // 한 번에 이동해야 하는 거리
        let totalMove = imageHeight - screenHeight
            
        offsetY = -totalMove
        // 1초마다 업데이트
        timer = Timer
            .scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
                // 1프레임당 이동 거리
                let movePerFrame = totalMove / (duration * 60)
                offsetY += movePerFrame
                // 이미지가 끝까지 올라가면 다시 시작
                if offsetY >= 0 {
                    offsetY = -totalMove
                    duration = 25
                }
            }
    }
}

#Preview {
    TimerBackgroundView()
}
