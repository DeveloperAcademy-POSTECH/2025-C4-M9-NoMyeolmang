//
//  AppCoordinator.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

/// # ``timé/AppCoordinator``
///
/// 애플리케이션의 네비게이션 상태를 관리하는 코디네이터입니다.
///
/// ## Overview
///
/// `AppCoordinator`는 SwiftUI NavigationStack과 연동하여 화면 전환을 관리합니다.
/// ``AppRoute`` 열거형 값들의 배열(`path`)을 통해 네비게이션 스택을 추적하며,
/// push, pop, replace 등의 네비게이션 작업을 제공합니다.
///
/// ## Topics
///
/// ### Navigation Management
///
/// - ``push(_:)``
/// - ``pop(_:)``
/// - ``popToRoot()``
/// - ``replaceLast(with:)``
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []

    /// 새로운 화면을 네비게이션 스택에 추가합니다.
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// 지정된 단계만큼 이전 화면으로 돌아갑니다.
    func pop(_ steps: Int = 1) {
        guard steps > 0, !path.isEmpty else { return }
        let stepsToRemove = min(steps, path.count)
        path.removeLast(stepsToRemove)
    }

    /// 루트 화면으로 돌아갑니다.
    func popToRoot() {
        path.removeLast(path.count)
    }

    /// 현재 화면을 새로운 화면으로 교체합니다.
    func replaceLast(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
}
