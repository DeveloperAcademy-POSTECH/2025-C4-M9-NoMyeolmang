//
//  FocusPersonalizater.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

/// # ``timé/Personalizater``
///
/// 사용자 학습 데이터를 활용하여 모델을 개인화하는 기능을 정의합니다.
protocol Personalizater {
    /// 사용자 학습 데이터를 사용하여 모델을 비동기적으로 업데이트합니다.
    func run(from userTrainingDataList: [UserTrainingData]) async throws -> Bool
}
