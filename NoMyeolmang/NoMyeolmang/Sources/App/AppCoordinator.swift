//
//  AppCoordinator.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
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
