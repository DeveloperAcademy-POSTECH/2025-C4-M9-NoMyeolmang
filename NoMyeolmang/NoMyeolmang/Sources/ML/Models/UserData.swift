//
//  Untitled.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/18/25.
//
import Foundation

struct UserData: Codable {
    var username: String
    var timestamp: Date
    var input: MLModelInput
    var label: Double
}
