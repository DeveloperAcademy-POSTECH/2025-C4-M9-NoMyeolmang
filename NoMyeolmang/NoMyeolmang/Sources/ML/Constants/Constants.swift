//
//  Constants.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//
// from Dodin_5_with_score_cleaned.csv

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
