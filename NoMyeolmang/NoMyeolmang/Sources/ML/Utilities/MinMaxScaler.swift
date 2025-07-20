//
//  MinMaxScaler.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

enum MinMaxScaler {
    static func scale(value: Double, min: Double, max: Double) -> Double {
        guard max != min else { return 0.0 }
        return (value - min) / (max - min)
    }
    static func scaleBlink(_ value: Double) -> Double {
        return scale(value: value, min: Constants.blinkCountPerMinValue, max: Constants.blinkCounterPerMaxValue)
    }
    
    static func scaleFace(_ value: Double) -> Double {
        return scale(value: value, min: Constants.faceBodyPresentMinValue, max: Constants.faceBodyPresentMaxValue)
    }
    
    static func scalePhone(_ value: Double) -> Double {
        return scale(value: value, min: Constants.phonePresentMinValue, max: Constants.phonePresentMaxValue)
    }
    
    static func scaleTime(_ value: Double) -> Double {
        return scale(value: value, min: Constants.elapsedTimeMinValue, max: Constants.elapsedTimeMaxValue)
    }
    
    static func scaleLabel(_ value: Double) -> Double {
        return scale(value: value, min: 1, max: 5)
    }
}
