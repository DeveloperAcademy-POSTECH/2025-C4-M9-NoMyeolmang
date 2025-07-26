//
//  ReportViewModel.swift
//  NoMyeolmang
//
//  Created by gabi on 7/26/25.
//

import Foundation

class ReportViewModel: ObservableObject {
    @Published var maxDistance = 30
    @Published var reachedDistance = 26
    @Published var reachedRatio = 79

    let actualTime = ActualTimerManager.shared.count
    let virtualTime = VirtualTimerManager.shared.count
    
    @Published var earthTime = ""
    @Published var focusTime = ""
    
    func calMaxDistance() {
        maxDistance = actualTime * 2 / 60
    }
    
    func calReachedDistance() {
        reachedDistance = virtualTime / 60
    }
    
    func calReachedRatio() {
        reachedRatio = reachedDistance * 100 / maxDistance
    }
    
    func calEarthTime() {
        earthTime = String(format: "%02d:%02d", actualTime / 60, actualTime % 60)
    }
    
    func calFocusTime() {
        focusTime = String(format: "%02d:%02d", virtualTime / 60, virtualTime % 60)
    }
}
