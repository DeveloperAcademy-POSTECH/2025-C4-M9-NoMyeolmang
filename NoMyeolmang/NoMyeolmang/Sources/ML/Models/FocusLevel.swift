//
//  FocusLevel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import Foundation

/// # ``timé/FocusLevel``
///
/// 집중도 점수를 5단계 레벨로 분류하고 각 레벨별 타이머 동작 설정을 제공합니다.
///
/// ## Overview
///
/// `FocusLevel`은 ``FocusScorePredictor``의 예측 결과를 5개 레벨로 분류합니다.
/// ``from(rawValue:)`` 메서드를 사용하여 0.0-5.0 범위의 점수를 해당 레벨로 변환하며,
/// 각 레벨은 ``tickSpeed()``와 ``backgroundDuration()`` 메서드를 통해 고유한
/// 타이머 설정을 제공합니다. 높은 집중도일수록 더 빠른 속도와 짧은 지속시간을 가집니다.
///
/// ### Focus Level Cases
///
/// - ``lv1``
///   최저 집중도 레벨 (0.0-1.0 범위)
/// - ``lv2``
///   낮은 집중도 레벨 (1.0-2.0 범위)
/// - ``lv3``
///   보통 집중도 레벨 (2.0-3.0 범위)
/// - ``lv4``
///   높은 집중도 레벨 (3.0-4.0 범위)
/// - ``lv5``
///   최고 집중도 레벨 (4.0-5.0 범위)
///
/// > Experiment: lv5는 매우 높은 집중도를 나타내며, 실제 사용자 데이터에서는 드물게 나타날 수 있습니다.
///
/// ### Level Configuration Methods
///
/// - ``tickSpeed()``
/// - ``backgroundDuration()``
/// - ``from(rawValue:)``
enum FocusLevel: Double, CaseIterable, Identifiable {
    case lv1 = 1.0
    case lv2 = 2.0
    case lv3 = 3.0
    case lv4 = 4.0
    case lv5 = 5.0

    func tickSpeed() -> Double {
        switch self {
        case .lv1: 2.0
        case .lv2: 1 / 0.7
        case .lv3: 1 / 0.8
        case .lv4: 1.0
        case .lv5: 0.5
        }
    }
    
    func backgroundDuration() -> Double {
        switch self {
        case .lv1: 45.0
        case .lv2: 37.0
        case .lv3: 33.0
        case .lv4: 30.0 // 기본 속도 (30초)
        case .lv5: 20.0
        }
    }
    
    static func from(rawValue: Double) -> FocusLevel? {
        switch rawValue {
        case 0.0 ..< 1.0:
            .lv1
        case 1.0 ..< 2.0:
            .lv2
        case 2.0 ..< 3.0:
            .lv3
        case 3.0 ..< 4.0:
            .lv4
        case 4.0 ... 5.0:
            .lv5
        default:
            .lv4
        }
    }
    
    var id: Double { rawValue }
}
