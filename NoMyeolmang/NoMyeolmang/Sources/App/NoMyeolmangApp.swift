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
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppCoordinator())
                .modelContainer(for: UserTrainingData.self)
        }
    }
}
