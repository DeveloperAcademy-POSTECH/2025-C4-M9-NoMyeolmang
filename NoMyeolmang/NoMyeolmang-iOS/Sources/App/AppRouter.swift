//
//  AppRouter.swift
//
//
//  Created by ohdodin on 7/10/25.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(to screen: AppRoute) {
        path.append(screen)
    }

    func reset() {
        path = NavigationPath()
    }

    func pop() {
        path.removeLast()
    }
}
