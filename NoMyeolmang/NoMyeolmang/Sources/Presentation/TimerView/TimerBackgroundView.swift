//
//  TimerBackgroundView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/23/25.
//

import SwiftUI

struct TimerBackgroundView: View {
    // MARK: 이미지 크기 따라 값 바꿔줄것
    // 이미지 크기
    let imageHeight: CGFloat = 4000
    let imageWidth: CGFloat = 1512
    
    // 화면 크기
    @State private var screenHeight: CGFloat = 600
    @State private var screenWidth: CGFloat = 800
    
    // 표시되는 이미지 크기
    @State private var displayWidth: CGFloat = 0
    @State private var displayHeight: CGFloat = 0
    
    // 애니메이션 진행 상태
    @State private var offsetY: CGFloat = 0
    
    // 타이머
    @State private var timer: Timer?
        
    // 전체 애니메이션 시간 (초) -> 100% 기준속도 기록해두기
    @State private var duration: Double = 12

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Image("timerBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .offset(y: offsetY)
                    .clipped()
                    .onAppear {
                        checkInitialPosition(screenSize: geo.size)
                        startLoopingAnimation()
                    }
                    .onDisappear {
                        timer?.invalidate()
                    }
                    .onChange(of: geo.size) { oldSize, newSize in
                        timer?.invalidate()
                        checkInitialPosition(screenSize: newSize)
                        startLoopingAnimation()
                    }
            }
        }
        .ignoresSafeArea()
        //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    func checkInitialPosition(screenSize: CGSize) {
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let imageAspectRatio = imageWidth / imageHeight
        let screenAspectRatio = screenWidth / screenHeight
        
        if imageAspectRatio > screenAspectRatio {
            // 이미지가 더 넓은 경우: 높이에 맞춤
            displayHeight = screenHeight
            displayWidth = displayHeight * imageAspectRatio
        } else {
            // 이미지가 더 좁은 경우: 너비에 맞춤
            displayWidth = screenWidth
            displayHeight = displayWidth / imageAspectRatio
        }

        // 이미지 하단 = 화면 하단
        offsetY = -(displayHeight - screenHeight) / 2
    }
            
    func startLoopingAnimation() {
        // 이미지 하단 = 화면 하단
        let startY = -(displayHeight - screenHeight) / 2
        // 이미지 상단 = 화면 상단
        let endY = (displayHeight - screenHeight) / 2
        
        offsetY = startY
        
        timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            // 이동 거리
            let totalDistance = endY - startY
            let movePerFrame = totalDistance / (duration * 60)
            
            offsetY += movePerFrame
            
            // 다시시작!
            if offsetY >= endY {
                offsetY = startY
            }
        }
    }
}

#Preview {
    TimerBackgroundView()
}
