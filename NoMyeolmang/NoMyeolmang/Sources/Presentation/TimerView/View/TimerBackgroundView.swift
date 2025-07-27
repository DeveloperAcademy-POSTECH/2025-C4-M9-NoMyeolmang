//
//  TimerBackgroundView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/23/25.
//

import SwiftUI

struct TimerBackgroundView: View {
    let animationDuration: Double
    // MARK: 이미지 크기 따라 값 바꿔줄것
    // 이미지 크기
    let imageHeight: CGFloat = 6140
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
                        startLoopingAnimation()  // 화면 크기 변경 시에는 리셋 필요
                    }
                    .onChange(of: animationDuration) { oldDuration, newDuration in
                        print("🚀 배경 속도 변경 감지: \(oldDuration) → \(newDuration)")
                        timer?.invalidate()
                        // 🆕 위치 보존하며 속도만 변경
                        startLoopingAnimationKeepingPosition()
                    }
            }
        }
        .ignoresSafeArea()
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
            
    // 🆕 기존 함수 (처음 시작용)
    func startLoopingAnimation() {
        let startY = -(displayHeight - screenHeight) / 2
        let endY = (displayHeight - screenHeight) / 2
        
        offsetY = startY  // 처음 위치로 초기화
        
        createAnimationTimer(startY: startY, endY: endY)
    }
    
    // 🆕 새 함수 (위치 보존용)
    func startLoopingAnimationKeepingPosition() {
        let startY = -(displayHeight - screenHeight) / 2
        let endY = (displayHeight - screenHeight) / 2
        
        // offsetY는 현재 위치 유지! 초기화하지 않음
        print("📍 현재 위치 유지: \(offsetY)")
        
        createAnimationTimer(startY: startY, endY: endY)
    }
    
    // 🆕 공통 타이머 생성 함수
    private func createAnimationTimer(startY: CGFloat, endY: CGFloat) {
        print("🎬 애니메이션 시작 - duration: \(animationDuration)초")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            let totalDistance = endY - startY
            let movePerFrame = totalDistance / (animationDuration * 60)
            
            offsetY += movePerFrame
            
            // 루프 처리
            if offsetY >= endY {
                print("🔄 애니메이션 루프 완료 - 재시작")
                offsetY = startY
            }
        }
        
        // 속도 로그
        let totalDistance = endY - startY
        let pixelsPerSecond = totalDistance / animationDuration
        print("⚡ 새로운 속도: \(pixelsPerSecond)px/s")
    }
}

#Preview {
    TimerBackgroundView(animationDuration: 30.0)
}
