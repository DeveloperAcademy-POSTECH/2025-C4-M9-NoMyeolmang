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
