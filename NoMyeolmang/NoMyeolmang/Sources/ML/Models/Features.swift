//
//  Featrues.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/25/25.
//


///
/// 집중도 예측 모델의 입력으로 사용되는 사용자 행동 특성 데이터입니다.
///
/// `Features`는 ``FocusScorePredictor``가 집중도를 예측하는 데 필요한 6가지 핵심 특성을
/// 포함합니다. 각 속성은 ``MinMaxScaler``의 해당 메서드를 통해 정규화되어 MLModel에 입력됩니다.
/// Codable 프로토콜을 준수하여 ``UserTrainingData``와 함께 데이터베이스에 저장할 수 있습니다.
///
/// ### Behavioral Features
///
/// - ``blinkCountPerMin``
/// - ``yawnPerMin``
/// - ``longBlinkPerMin``
///
/// ### Presence Features
///
/// - ``faceBodyPresent``
/// - ``phonePresent``
///
/// ### Time Features
///
/// - ``elapsedTime``
struct Features: Codable, Sendable {
    /// 분당 일반적인 눈 깜빡임 횟수 (``Constants/blinkCountPerMinValue``-``Constants/blinkCounterPerMaxValue`` 범위)
    let blinkCountPerMin: Double
    /// 얼굴이나 몸체 감지 여부 (0.0: 없음, 1.0: 있음)
    let faceBodyPresent: Double
    /// 휴대폰 사용 여부 (0.0: 사용 안함, 1.0: 사용함)
    let phonePresent: Double
    /// 타이머 시작 후 경과 시간(분) (``Constants/elapsedTimeMinValue``-``Constants/elapsedTimeMaxValue`` 범위)
    let elapsedTime: Double
    /// 분당 하품 횟수 (``Constants/yawnCountPerMinValue``-``Constants/yawnCounterPerMaxValue`` 범위)
    let yawnPerMin: Double
    /// 분당 긴 눈 깜빡임 횟수 (``Constants/longBlinkCountPerMinValue``-``Constants/longBlinkCounterPerMaxValue`` 범위)
    let longBlinkPerMin: Double
}
