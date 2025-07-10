//
//  AppRouter.swift
//
//
//  Created by ohdodin on 7/10/25.
//

import Foundation

final class AppRouter: ObservableObject {
    @Published var path: [AppRoute] = []

    func push(to screen: AppRoute) {
        path.append(screen)
    }

    func reset() {
        path = []
    }

    func pop() {
        path.removeLast()
    }
}
