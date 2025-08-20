//
//  BlinkDetector.swift
//  timé
//
//  Created by Muchan Kim on 8/15/25.
//

import Vision

protocol BlinkDetector {
    func detect(from landmarks: VNFaceLandmarks2D?) -> Int
    func reset()
}

protocol YawnDetector {
    func detect(from landmarks: VNFaceLandmarks2D?) -> Int
    func reset()
}
