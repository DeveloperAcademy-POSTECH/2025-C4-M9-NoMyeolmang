//
//  YawnDetector.swift
//  NoMyeolmang
//
//  Created by Moo on 7/21/25.
//

import Vision
///
/// VNDetectFaceLandmarksRequest를 사용하여 하품을 감지하고 횟수를 추적합니다.
///
/// `VisionYawnDetector`는 ``AnalysisManager``에서 전달받은 `VNFaceLandmarks2D`의 입술 영역을 분석하여
/// 하품을 감지합니다. Mouth Aspect Ratio(MAR) 알고리즘을 사용하여 입의 열림 정도를 계산하고,
/// 임계값을 초과하는 패턴을 통해 하품을 인식합니다.
///
/// 잘못된 감지를 방지하기 위해 연속된 5개 프레임에서 상태 변화가 확인되어야만 하품으로 인정하며,
/// 감지된 총 하품 횟수는 ``Features`` 객체의 ``yawnPerMin`` 속성으로 사용됩니다.
///
/// ### Detecting Yawns
///
/// - ``detect(from:)``
/// - ``reset()``
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
