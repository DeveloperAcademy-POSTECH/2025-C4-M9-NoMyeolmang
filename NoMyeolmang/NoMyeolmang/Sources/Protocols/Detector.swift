//
//  Detector.swift
//  timé
//
//  Created by Muchan Kim on 8/15/25.
//

import Vision

/// # ``timé/BlinkDetector``
///
/// VNFaceLandmarks2D에서 눈 깜빡임을 감지하는 기능을 정의합니다.
protocol BlinkDetector {
    /// 얼굴 랜드마크에서 깜빡임을 감지하고 총 횟수를 반환합니다.
    func detect(from landmarks: VNFaceLandmarks2D?) -> Int
    /// 감지기의 상태를 초기화합니다.
    func reset()
}

/// # ``timé/YawnDetector``
///
/// VNFaceLandmarks2D에서 하품을 감지하는 기능을 정의합니다.
protocol YawnDetector {
    /// 얼굴 랜드마크에서 하품을 감지하고 총 횟수를 반환합니다.
    func detect(from landmarks: VNFaceLandmarks2D?) -> Int
    /// 감지기의 상태를 초기화합니다.
    func reset()
}
