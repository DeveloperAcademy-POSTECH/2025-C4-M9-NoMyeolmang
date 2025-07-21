//
//  MLModelInput.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

import Foundation

struct MLModelInput: Codable {
    let blinkCountPerMin: Double
    let faceBodyPresent: Double
    let phonePresent: Double
    let elapsedTime: Double
    let yawnCountPerMin: Double
    let longBlinkCountPerMin: Double
}
