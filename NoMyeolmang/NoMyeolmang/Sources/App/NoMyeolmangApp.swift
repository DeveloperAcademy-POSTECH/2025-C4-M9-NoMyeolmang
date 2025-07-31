//
//  NoMyeolmangApp.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/29/25.
//

import SwiftData
import SwiftUI

@main
struct NoMyeolmangApp: App {
    init() {
            #if DEBUG
            UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
            #endif
        }
    
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
