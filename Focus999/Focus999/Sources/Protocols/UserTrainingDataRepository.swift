//
//  UserTrainingDataRepository.swift
//  NoMyeolmang
//
//  Created by Moo on 7/24/25.
//

/// # ``timé/UserTrainingDataRepository``
///
/// 사용자 행동 패턴 데이터를 저장하고 모델 개인화에 활용하기 위한 저장소 인터페이스입니다.
protocol UserTrainingDataRepository {
    /// 사용자 학습 데이터를 저장합니다.
    func write(input data: [UserTrainingData]) async throws -> Bool
    /// 지정된 개수의 데이터를 조회합니다.
    func fetch(count: Int) async throws -> [UserTrainingData]
    /// 사용자 점수를 업데이트합니다.
    func update(to newScore: Double, count: Int) async throws -> Bool
    /// 모든 데이터를 삭제합니다.
    func clear() async throws -> Bool
}
