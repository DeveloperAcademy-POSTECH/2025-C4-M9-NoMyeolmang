//
//  MinMaxScaler.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

enum MinMaxScaler {
    static func scaleBlink(_ value: Double) -> Double {
        return safeScale(
            value: value,
            min: Constants.blinkCountPerMinValue,
            max: Constants.blinkCounterPerMaxValue
        )
    }

    static func scaleFace(_ value: Double) -> Double {
        return scale(
            value: value,
            min: Constants.faceBodyPresentMinValue,
            max: Constants.faceBodyPresentMaxValue
        )
    }

    static func scalePhone(_ value: Double) -> Double {
        return scale(
            value: value,
            min: Constants.phonePresentMinValue,
            max: Constants.phonePresentMaxValue
        )
    }

    static func scaleTime(_ value: Double) -> Double {
        return scale(
            value: value,
            min: Constants.elapsedTimeMinValue,
            max: Constants.elapsedTimeMaxValue
        )
    }

    static func scaleYawn(_ value: Double) -> Double {
        return safeScale(
            value: value,
            min: Constants.yawnCountPerMinValue,
            max: Constants.yawnCounterPerMaxValue
        )
    }

    static func scaleLongBlink(_ value: Double) -> Double {
        return safeScale(
            value: value,
            min: Constants.longBlinkCountPerMinValue,
            max: Constants.longBlinkCounterPerMaxValue
        )
    }

    private static func scale(value: Double, min: Double, max: Double) -> Double {
        guard max != min else { return 0.0 }
        return (value - min) / (max - min)
    }

    private static func softClip(value: Double, min: Double, max: Double) -> Double {
        return Swift.max(min, Swift.min(value, max))
    }

    private static func safeScale(value: Double, min: Double, max: Double) -> Double {
        let clippedValue = softClip(value: value, min: min, max: max)
        return scale(value: clippedValue, min: min, max: max)
    }
}
