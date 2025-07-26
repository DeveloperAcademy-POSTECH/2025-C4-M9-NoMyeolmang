//
//  FocusLevel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import Foundation

enum FocusLevel: Double, CaseIterable, Identifiable {
    case lv1 = 1.0
    case lv2 = 2.0
    case lv3 = 3.0
    case lv4 = 4.0
    case lv5 = 5.0

    func tickSpeed() -> Double {
        switch self {
        case .lv1: return 2.0
        case .lv2: return 1/0.7
        case .lv3: return 1/0.8
        case .lv4: return 1.0
        case .lv5: return 0.5
        }
    }
    
    func backgroundDuration() -> Double {
        switch self {
        case .lv1: return 45.0
        case .lv2: return 37.0
        case .lv3: return 33.0
        case .lv4: return 30.0  // 기본 속도 (30초)
        case .lv5: return 20.0
        }
    }
    
    static func from(rawValue: Double) -> FocusLevel? {
        return FocusLevel(rawValue: rawValue)
    }
    
    var id: Double { rawValue }
}
