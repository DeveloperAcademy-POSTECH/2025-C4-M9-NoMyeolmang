//
//  HomeViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/10/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    private let router: AppRouter
    @Published var isTapped: Bool = false

    init(router: AppRouter) {
        self.router = router
    }
}
