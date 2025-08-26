//
//  NoMyeolmangApp.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/29/25.
//

import SwiftData
import SwiftUI

/// # ``timé/NoMyeolmangApp``
///
/// timé 애플리케이션의 메인 진입점이며 SwiftData 모델 컨테이너를 설정합니다.
///
/// ## Overview
///
/// `NoMyeolmangApp`은 SwiftUI App 프로토콜을 구현하여 애플리케이션의 생명주기를 관리합니다.
/// ``UserTrainingData``를 위한 SwiftData ModelContainer를 초기화하고, ``ModuleFactory``를 통해
/// 의존성 주입을 설정합니다. ``AppDelegate``와 ``AppCoordinator``를 연결하여 전체 앱 아키텍처를 구성합니다.
///
/// > Warning: SwiftData ModelContainer 생성에 실패하면 앱이 fatalError로 종료됩니다. 이는 데이터 저장소가 앱의 핵심 기능이기 때문입니다.
@main
struct NoMyeolmangApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var coordinator = AppCoordinator()
    @State private var moduleFactory: ModuleFactory?

    var modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: UserTrainingData.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
        
    var body: some Scene {
        WindowGroup {
            if let moduleFactory = moduleFactory {
                RootView(moduleFactory: moduleFactory)
                    .environmentObject(coordinator)
            } else {
                ProgressView()
                    .onAppear {
                        self.moduleFactory = ModuleFactory(modelContext: modelContainer.mainContext)
                        
                        appDelegate.moduleFactory = self.moduleFactory
                        appDelegate.coordinator = coordinator
                    }
            }
        }
        .windowStyle(.hiddenTitleBar)
    }
}
