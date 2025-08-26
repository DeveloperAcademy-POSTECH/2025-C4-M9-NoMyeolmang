//
//  AppRoute.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import Foundation

/// # ``timé/AppRoute``
///
/// 애플리케이션의 네비게이션 라우트를 정의하는 열거형입니다.
///
/// ## Overview
///
/// `AppRoute`는 ``AppCoordinator``에서 사용하는 화면 전환 경로를 나타냅니다.
/// SwiftUI NavigationStack의 path 배열에 저장되어 화면 간 이동을 관리합니다.
///
/// ## Topics
///
/// ### Navigation Routes
///
/// - ``timerSetting``
/// - ``timer``
/// - ``feedback``
/// - ``report``
enum AppRoute: Hashable {
    /// 타이머 설정 화면
    case timerSetting
    /// 메인 타이머 화면
    case timer
    /// 피드백 입력 화면
    case feedback
    /// 세션 결과 리포트 화면
    case report
}
