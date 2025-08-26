//
//  Predictor.swift
//  NoMyeolmang
//
//  Created by Muchan Kim on 7/23/25.
//

/// # ``timé/Predictor``
///
/// 사용자 행동 특성으로부터 집중도 점수를 예측하는 기능을 정의합니다.
protocol Predictor {
    /// 행동 특성 데이터로부터 집중도 점수를 예측하고 UserTrainingData를 반환합니다.
    func run(from features: Features) -> UserTrainingData
}
