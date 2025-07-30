//
//  NoMyeolmangApp.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/24/25.
//

import SwiftData
import SwiftUI

@main
struct NoMyeolmangApp: App {
    @State private var coordinator = AppCoordinator()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // 앱 실행 시 사용 가능한 폰트 이름 로그 출력
    init() {
        for name in NSFontManager.shared.availableFonts {
            if name.lowercased().contains("pretendard") || name.lowercased().contains("spoqa") {
                print("🌠 \(name)")
            }
        }
    }
    
    var modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: UserTrainingData.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RootView(
                moduleFactory: ModuleFactory(modelContext: modelContainer.mainContext)
            )
            .environmentObject(coordinator)
        }
    }
}
