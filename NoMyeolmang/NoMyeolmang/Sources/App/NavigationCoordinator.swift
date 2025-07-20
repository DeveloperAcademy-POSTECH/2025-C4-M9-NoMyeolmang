//
//  NavigationCoordinator.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case notice
    case start
    case timerSetting
    case timer
    case feedback
    case report
}

class NavigationCoordinator: ObservableObject {
    @Published var path: [AppRoute] = [.start]
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }

    func reset() {
        path = [.start]
    }
}
