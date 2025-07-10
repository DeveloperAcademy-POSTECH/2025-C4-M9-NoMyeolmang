//
//  RootView.swift
//
//
//  Created by ohdodin on 7/10/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(viewModel: HomeViewModel(router: router))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(viewModel: HomeViewModel(router: router))
                    }
                }

        }
    }
}

#Preview {
    RootView()
}
