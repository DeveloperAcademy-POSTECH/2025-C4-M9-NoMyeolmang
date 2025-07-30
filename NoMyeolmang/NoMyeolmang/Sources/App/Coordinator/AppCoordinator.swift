//
//  AppCoordinator.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop(_ steps: Int = 1) {
        guard steps > 0, !path.isEmpty else { return }
        let c = min(steps, path.count)
        path.removeLast(c)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func replaceLast(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
}
