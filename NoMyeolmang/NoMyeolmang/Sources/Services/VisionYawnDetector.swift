//
//  YawnDetector.swift
//  NoMyeolmang
//
//  Created by Moo on 7/21/25.
//

import Vision

final class VisionYawnDetector: YawnDetector {
    private let marThreshold: CGFloat = 1.6
    private let requiredFrameCount: Int = 5

    private var yawnCount: Int = 0
    private var lastYawnState: Bool = false
    private var consecutiveFrameCount: Int = 0

    func detect(from landmarks: VNFaceLandmarks2D?) -> Int {
        guard let outerLips = landmarks?.outerLips else {
            return yawnCount
        }
        let mar = calculateMouthAspectRatio(mouth: outerLips)
        let isYawningNow = mar > marThreshold
        updateYawnState(isYawning: isYawningNow)
        return yawnCount
    }

    func reset() {
        yawnCount = 0
        lastYawnState = false
        consecutiveFrameCount = 0
    }

    private func updateYawnState(isYawning: Bool) {
        if isYawning == lastYawnState {
            consecutiveFrameCount = 0
        } else {
            consecutiveFrameCount += 1
            if consecutiveFrameCount >= requiredFrameCount {
                let previousState = lastYawnState
                lastYawnState = isYawning
                consecutiveFrameCount = 0
                if !previousState && isYawning {
                    yawnCount += 1
                }
            }
        }
    }

    private func calculateMouthAspectRatio(mouth: VNFaceLandmarkRegion2D) -> CGFloat {
        let points = mouth.normalizedPoints
        guard points.count >= 8 else { return 0.0 }
        let width = distance(from: points[0], to: points[4])
        let height = distance(from: points[2], to: points[10])
        guard width > 0 else { return 0.0 }
        let mar = height / width
        if mar < 0 || mar > 2.0 { return 0.0 }
        return mar
    }

    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx * dx + dy * dy)
    }
}
