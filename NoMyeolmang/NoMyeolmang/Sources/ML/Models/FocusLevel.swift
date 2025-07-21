//
//  FocusLevel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import Foundation

enum FocusLevel: Int, CaseIterable, Identifiable {
    case lv1 = 1
    case lv2 = 2
    case lv3 = 3
    case lv4 = 4
    case lv5 = 5

    func tickSpeed() -> Double {
        switch self {
        case .lv1: return 2.0
        case .lv2: return 1/0.7
        case .lv3: return 1/0.8
        case .lv4: return 1.0
        case .lv5: return 0.5
        }
    }
    
    static func from(rawValue: Int) -> FocusLevel? {
        return FocusLevel(rawValue: rawValue)
    }
    
    var id: Int { rawValue }
}
