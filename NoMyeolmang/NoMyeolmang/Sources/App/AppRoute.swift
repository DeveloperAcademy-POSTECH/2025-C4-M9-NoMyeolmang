//
//  AppRoute.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import Foundation

enum AppRoute: Hashable {
    case timerSetting
    case timer(goalTime: TimeInterval)
    case feedback
    case report
}
