//
//  ModelRepository.swift
//  NoMyeolmang
//
//  Created by Moo on 12/5/25.
//

import CoreML

/// # ``timé/ModelRepository``
///
/// 업데이트된 머신러닝 모델을 저장하는 저장소 인터페이스입니다.
protocol ModelRepository {
    /// MLUpdateContext에서 업데이트된 모델을 저장합니다.
    func save(from context: MLUpdateContext) async throws
}
