//
//  Detector.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/21/25.
//

import Vision

final class VisionBlinkDetector: BlinkDetector {
    private let earThreshold: CGFloat = 0.18
    private let requiredFrameCount: Int = 3

    private var blinkCount: Int = 0
    private var lastEyeState: Bool = false
    private var consecutiveFrameCount: Int = 0

    func detect(from landmarks: VNFaceLandmarks2D?) -> Int {
        guard let leftEye = landmarks?.leftEye,
              let rightEye = landmarks?.rightEye else {
            return blinkCount
        }
        let leftEAR = calculateEyeAspectRatio(eye: leftEye)
        let rightEAR = calculateEyeAspectRatio(eye: rightEye)
        let averageEAR = (leftEAR + rightEAR) / 2.0
        let eyesClosed = averageEAR < earThreshold
        updateBlinkState(eyesClosed: eyesClosed)
        return blinkCount
    }

    func reset() {
        blinkCount = 0
        lastEyeState = false
        consecutiveFrameCount = 0
    }

    private func updateBlinkState(eyesClosed: Bool) {
        if eyesClosed == lastEyeState {
            consecutiveFrameCount = 0
        } else {
            consecutiveFrameCount += 1
            if consecutiveFrameCount >= requiredFrameCount {
                let previousState = lastEyeState
                lastEyeState = eyesClosed
                consecutiveFrameCount = 0
                if previousState && !eyesClosed {
                    blinkCount += 1
                }
            }
        }
    }

    private func calculateEyeAspectRatio(eye: VNFaceLandmarkRegion2D) -> CGFloat {
        let points = eye.normalizedPoints
        guard points.count >= 6 else { return 0.0 }
        let pointCount = points.count
        let width = distance(from: points[0], to: points[pointCount/2])
        var heights: [CGFloat] = []
        
        for i in 1..<pointCount/2 {
            let topPoint = points[i]
            let bottomPoint = points[pointCount - i]
            heights.append(distance(from: topPoint, to: bottomPoint))
        }
        let averageHeight = heights.reduce(0, +) / CGFloat(heights.count)
        guard width > 0 else { return 0.0 }
        let ear = averageHeight / width
        if ear < 0 || ear > 1.0 { return 0.0 }
        return ear
    }

    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx * dx + dy * dy)
    }
}
