//
//  HomeViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/10/25.
//

import Combine  // C가 F보다 먼저 와야 함
import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    private let router: AppRouter
    @Published var isTapped: Bool = false

    init(router: AppRouter) {
        self.router = router
    }
}
