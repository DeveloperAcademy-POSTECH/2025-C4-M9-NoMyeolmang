//
//  Detector.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/21/25.
//

import Vision

/// # ``timé/VisionBlinkDetector``
///
/// VNDetectFaceLandmarksRequest를 사용하여 눈 깜빡임을 감지하고 횟수를 추적합니다.
///
/// `VisionBlinkDetector`는 ``AnalysisManager``에서 전달받은 `VNFaceLandmarks2D`의 눈 영역을 분석하여
/// 눈 깜빡임을 감지합니다. Eye Aspect Ratio(EAR) 알고리즘을 사용하여 양쪽 눈의 열림 정도를 계산하고,
/// 임계값 이하로 떨어졌다가 다시 올라가는 패턴을 통해 깜빡임을 인식합니다.
///
/// 잘못된 감지를 방지하기 위해 연속된 3개 프레임에서 상태 변화가 확인되어야만 깜빡임으로 인정하며,
/// 감지된 총 깜빡임 횟수는 ``Features`` 객체의 ``Features/blinkCountPerMin`` 속성으로 사용됩니다.
///
/// > Tip: EAR 임계값(0.18)은 일반적인 깜빡임 감지에 최적화되어 있지만, 개인차에 따라 조정이 필요할 수 있습니다.
///
/// ### Detecting Blinks
///
/// - ``detect(from:)``
/// - ``reset()``
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
        
        for index in 1..<pointCount/2 {
            let topPoint = points[index]
            let bottomPoint = points[pointCount - index]
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
