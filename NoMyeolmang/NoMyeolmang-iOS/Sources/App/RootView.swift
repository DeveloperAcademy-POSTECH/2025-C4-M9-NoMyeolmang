//
//  RootView.swift
//
//
//  Created by ohdodin on 7/10/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    }
                }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppRouter())
}
