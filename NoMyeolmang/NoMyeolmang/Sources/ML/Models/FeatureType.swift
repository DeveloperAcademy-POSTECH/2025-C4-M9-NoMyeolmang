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
            return (Constants.blinkCountPerMinValue, Constants.blinkCounterPerMaxValue)
        case .longBlink:
            return (Constants.longBlinkCountPerMinValue, Constants.longBlinkCounterPerMaxValue)
        case .face:
            return (Constants.faceBodyPresentMinValue, Constants.faceBodyPresentMaxValue)
        case .phone:
            return (Constants.phonePresentMinValue, Constants.phonePresentMaxValue)
        case .yawn:
            return (Constants.yawnCountPerMinValue, Constants.yawnCounterPerMaxValue)
        case .elapsedTime:
            return (Constants.elapsedTimeMinValue, Constants.elapsedTimeMaxValue)
        }
    }
}

extension FeatureType {
    var isNeedClip: Bool {
        switch self {
        case .shortBlink, .longBlink, .yawn:
            return true
        case .face, .phone, .elapsedTime:
            return false
        }
    }
}
