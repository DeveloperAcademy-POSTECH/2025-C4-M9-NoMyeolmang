//
//  MinMaxScaler.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

/// # ``timé/MinMaxScaler``
///
/// 특성 데이터를 0-1 범위로 정규화하는 스케일링 유틸리티를 제공합니다.
///
/// `MinMaxScaler`는 각 행동 특성을 머신러닝 모델에 적합한 0-1 범위로 변환합니다.
/// 범위를 벗어나는 값들은 `softClip`을 통해 안전하게 처리되며, 분모가 0인 경우를 
/// 방지하는 안전한 스케일링 로직을 포함합니다. 모든 스케일링은 ``Constants``에서 
/// 정의된 최솟값과 최댓값을 기준으로 수행되며, ``FocusScorePredictor``와 
/// ``FocusPersonalizater``에서 ``Features`` 데이터 전처리에 사용됩니다.
///
///
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
