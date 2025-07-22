//
//  FaceAbsenceTimer.swift
//  NoMyeolmang
//
//  Created by Moo on 7/21/25.
//

import Foundation

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
            return accumulatedAbsenceTime + Date().timeIntervalSince(start)
        } else {
            return accumulatedAbsenceTime
        }
    }

    func reset() {
        absenceStartTime = nil
        accumulatedAbsenceTime = 0
        isFacePresent = true
    }
}
