//
//  Personalizer.swift
//  timé
//
//  Created by Moo on 12/6/25.
//

/// # ``timé/Personalizer``
///
/// 사용자 학습 데이터를 활용하여 모델을 개인화하는 기능을 정의합니다.
protocol Personalizer {
    /// 사용자 학습 데이터를 사용하여 모델을 비동기적으로 업데이트합니다.
    /// 성공 시 정상 완료되며, 실패 시 에러를 throw합니다.
    func run(from userTrainingDataList: [UserTrainingData]) async throws
}
