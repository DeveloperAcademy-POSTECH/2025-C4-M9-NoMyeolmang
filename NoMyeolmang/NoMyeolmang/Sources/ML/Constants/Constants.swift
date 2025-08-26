//
//  Constants.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//
// from Dodin_5_with_score_cleaned.csv

/// # ``timé/Constants``
///
/// 머신러닝 모델의 특성 데이터 정규화를 위한 최솟값과 최댓값 상수를 제공합니다.
///

/// `Constants`는 각 행동 특성의 Min-Max 정규화에 필요한 범위 값들을 정의합니다.
/// 이 값들은 훈련 데이터셋(Dodin_5_with_score_cleaned.csv)에서 도출된 실제 범위를 
/// 기반으로 하며, 일관된 데이터 전처리를 보장합니다. ``MinMaxScaler``의 각 메서드에서 
/// 이 상수들을 사용하여 ``Features`` 데이터를 정규화합니다.
///
/// ### Blink Count Constants
///
/// - ``blinkCountPerMinValue``
/// - ``blinkCounterPerMaxValue``
///
/// ### Face/Body Presence Constants
///
/// - ``faceBodyPresentMinValue``
/// - ``faceBodyPresentMaxValue``
///
/// ### Phone Usage Constants
///
/// - ``phonePresentMinValue``
/// - ``phonePresentMaxValue``
///
/// ### Elapsed Time Constants
///
/// - ``elapsedTimeMinValue``
/// - ``elapsedTimeMaxValue``
///
/// ### Yawn Count Constants
///
/// - ``yawnCountPerMinValue``
/// - ``yawnCounterPerMaxValue``
///
/// ### Long Blink Count Constants
///
/// - ``longBlinkCountPerMinValue``
/// - ``longBlinkCounterPerMaxValue``
enum Constants {
    // 눈 깜빡임 빈도(분)
    static let blinkCountPerMinValue: Double = 5.0
    static let blinkCounterPerMaxValue: Double  = 20.0
    
    // 자리 비움 시간
    static let faceBodyPresentMinValue: Double = 0.0
    static let faceBodyPresentMaxValue: Double  = 1.0
    
    // 휴대폰 사용 시간
    static let phonePresentMinValue: Double  = 0.0
    static let phonePresentMaxValue: Double  = 1.0
    
    // 경과 시간
    static let elapsedTimeMinValue: Double  = 1.0
    static let elapsedTimeMaxValue: Double  = 30.0
    
    // 하품 빈도(분)
    static let yawnCountPerMinValue: Double = 0.0
    static let yawnCounterPerMaxValue: Double = 5.0
    
    // 긴 눈 깜빡임 빈도(분)
    static let longBlinkCountPerMinValue: Double = 0.0
    static let longBlinkCounterPerMaxValue: Double = 4.0
}
