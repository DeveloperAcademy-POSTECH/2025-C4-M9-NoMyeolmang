//
//  TimerViewModel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import Combine
import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var timeElapsed: TimeInterval = 0
    
    private let manager: TimerManager
        private var cancellables = Set<AnyCancellable>()

        init(manager: TimerManager = TimerManager()) {
            self.manager = manager
            bind()
        }

        private func bind() {
            manager.timePublisher
                .receive(on: RunLoop.main)
                .assign(to: &$timeElapsed)
        }

        func startTimer() {
            manager.start()
        }

        func stopTimer() {
            manager.clear()
        }
}
