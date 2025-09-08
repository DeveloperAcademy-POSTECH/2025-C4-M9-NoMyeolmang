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
/// 범위를 벗어나는 값들은 `clip`을 통해 안전하게 처리되며, 분모가 0인 경우를
/// 방지하는 안전한 스케일링 로직을 포함합니다. 모든 스케일링은 ``FeatureType``에서
/// 정의된 최솟값과 최댓값을 기준으로 수행되며, ``FocusScorePredictor``와
/// ``FocusPersonalizater``에서 ``Features`` 데이터 전처리에 사용됩니다.
///
import CoreML

enum MinMaxScaler {
    /// Features 객체의 모든 특성을 정규화하여 배열로 반환합니다.
    ///
    /// 이 메서드는 ``Features``의 6가지 특성을 각각의 ``FeatureType``에 맞게
    /// 0-1 범위로 정규화합니다. 클리핑이 필요한 특성은 자동으로 안전하게 처리됩니다.
    ///
    /// - Parameter features: 정규화할 특성 데이터
    /// - Returns: 정규화된 값들의 배열 (순서: blink, face, phone, time, yawn, longBlink)
    static func scale(_ features: Features) -> [Double] {
        return [
            scaleValue(value: features.blinkCountPerMin, for: .shortBlink),
            scaleValue(value: features.faceBodyPresent, for: .face),
            scaleValue(value: features.phonePresent, for: .phone),
            scaleValue(value: features.elapsedTime, for: .elapsedTime),
            scaleValue(value: features.yawnPerMin, for: .yawn),
            scaleValue(value: features.longBlinkPerMin, for: .longBlink)
        ]
    }
    
    private static func scaleValue(value: Double, for featureType: FeatureType) -> Double {
        let (min, max) = featureType.range
        if featureType.isNeedClip {
            return safeScale(value: value, min: min, max: max)
        } else {
            return normalize(value: value, min: min, max: max)
        }
    }

    private static func normalize(value: Double, min: Double, max: Double) -> Double {
        guard max != min else { return 0.0 }
        return (value - min) / (max - min)
    }

    private static func clip(value: Double, between min: Double, and max: Double) -> Double {
        return Swift.max(min, Swift.min(value, max))
    }

    private static func safeScale(value: Double, min: Double, max: Double) -> Double {
        let clippedValue = clip(value: value, between: min, and: max)
        return normalize(value: clippedValue, min: min, max: max)
    }
}
