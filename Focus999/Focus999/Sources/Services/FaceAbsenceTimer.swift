//
//  FaceAbsenceTimer.swift
//  NoMyeolmang
//
//  Created by Moo on 7/21/25.
//

import Foundation

/// # ``timé/FaceAbsenceTimer``
///
/// 사용자의 얼굴 부재 시간을 실시간으로 추적하고 누적 계산합니다.
///
/// `FaceAbsenceTimer`는 ``AnalysisManager``에서 전달받은 얼굴 감지 결과를 바탕으로
/// 사용자가 화면에서 사라진 시간을 누적하여 계산합니다. 얼굴이 감지되지 않는 순간부터
/// 시간을 측정하기 시작하며, 다시 얼굴이 감지되면 측정을 중단하고 누적 시간에 추가합니다.
///
/// 측정된 총 부재 시간은 ``Features`` 객체의 ``Features/faceBodyPresent`` 속성으로 사용되어
/// 사용자의 집중도 분석에 활용됩니다. 부재 시간이 길수록 집중도가 낮다고 판단됩니다.
///
/// ### Tracking Face Presence
///
/// - ``update(isFacePresent:)``
/// - ``totalAbsenceTime``
/// - ``reset()``
final class FaceAbsenceTimer {
    private var absenceStartTime: Date?
    private var accumulatedAbsenceTime: TimeInterval = 0
    private(set) var isFacePresent: Bool = true

    func update(isFacePresent: Bool) {
        if !isFacePresent {
            if absenceStartTime == nil {
                absenceStartTime = Date()
            }
        } else {
            if let start = absenceStartTime {
                accumulatedAbsenceTime += Date().timeIntervalSince(start)
                absenceStartTime = nil
            }
        }
        self.isFacePresent = isFacePresent
    }

    var totalAbsenceTime: TimeInterval {
        if let start = absenceStartTime {
            accumulatedAbsenceTime + Date().timeIntervalSince(start)
        } else {
            accumulatedAbsenceTime
        }
    }

    func reset() {
        absenceStartTime = nil
        accumulatedAbsenceTime = 0
        isFacePresent = true
    }
}
