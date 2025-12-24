//
//  FeatureType.swift
//  timé
//
//  Created by Muchan Kim on 9/7/25.
//

enum FeatureType {
    case shortBlink
    case longBlink
    case face
    case phone
    case yawn
    case elapsedTime
}

typealias MinMaxRange = (min: Double, max: Double)

extension FeatureType {
    var range: MinMaxRange {
        switch self {
        case .shortBlink:
            (Constants.blinkCountPerMinValue, Constants.blinkCounterPerMaxValue)
        case .longBlink:
            (Constants.longBlinkCountPerMinValue, Constants.longBlinkCounterPerMaxValue)
        case .face:
            (Constants.faceBodyPresentMinValue, Constants.faceBodyPresentMaxValue)
        case .phone:
            (Constants.phonePresentMinValue, Constants.phonePresentMaxValue)
        case .yawn:
            (Constants.yawnCountPerMinValue, Constants.yawnCounterPerMaxValue)
        case .elapsedTime:
            (Constants.elapsedTimeMinValue, Constants.elapsedTimeMaxValue)
        }
    }
}

extension FeatureType {
    var isNeedClip: Bool {
        switch self {
        case .shortBlink, .longBlink, .yawn:
            true
        case .face, .phone, .elapsedTime:
            false
        }
    }
}
