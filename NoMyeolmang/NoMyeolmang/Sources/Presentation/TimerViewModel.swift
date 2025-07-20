//
//  TimerViewModel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var goalTime: TimeInterval
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var actualElapsedTime: TimeInterval = 0
    @Published var virtualFocusTime: TimeInterval = 0
    @Published var focusLevel: FocusLevel = FocusLevel.lv4
    
    init(goalTime: TimeInterval){
        self.goalTime = goalTime
    }
    
    func addTime() {
        actualElapsedTime += 1
        virtualFocusTime += focusLevel.convertedTime()
    }
    
    func calcActualTime() -> Int {
        return Int(goalTime - actualElapsedTime)
    }
    
    func calcVirtualTime() -> Int {
        return Int(goalTime - virtualFocusTime)
    }
}
