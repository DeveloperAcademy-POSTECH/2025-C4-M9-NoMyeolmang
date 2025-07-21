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
    @Published var tickCount: Int = 0
    
    init() {
        ActualTimerManager.shared.onTick = { [weak self] count in
            self?.tickCount = count
            print("타이머 tick")
        }
        VertualTimerManager.shared.onTick = { [weak self] count in
            self?.tickCount = count
            print("타이머 tick")
        }
        ActualTimerManager.shared.start()
        VertualTimerManager.shared.start()
    }
    
    func stop() {
        ActualTimerManager.shared.stop()
        VertualTimerManager.shared.stop()
    }
}
