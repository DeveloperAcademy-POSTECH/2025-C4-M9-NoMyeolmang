# Vision & ML Guide

## Overview

Vision 프레임워크에서 수집된 사용자 행동 데이터를 분석하여 실시간으로 포커스 점수를 예측하고, 개인화된 학습을 통해 모델을 지속적으로 개선하는 핵심 시스템입니다.

### Core Capabilities
- **Real-time Focus Prediction**: Vision 데이터를 통한 즉시 집중력 점수 예측
- **Personalized Learning**: 사용자별 행동 패턴 학습 및 모델 업데이트
- **Data Normalization**: 다양한 범위의 입력 데이터를 0.0~1.0으로 정규화
- **Model Management**: 번들 모델과 업데이트된 모델의 동적 전환

---

## Architecture

### ML Pipeline Structure

Vision Data → Features → MinMaxScaler → ML Model → Focus Score → FocusLevel
→ UserTrainingData → FocusPersonalizater → Model Update

### Data Flow
1. **Input Processing**: Vision 프레임워크에서 수집된 6개 특성 데이터
2. **Normalization**: MinMaxScaler를 통한 데이터 정규화
3. **Prediction**: Core ML 모델을 통한 집중력 점수 예측
4. **Learning**: 사용자 피드백을 통한 모델 개인화
5. **Output**: 0.0~1.0 범위의 포커스 점수와 5단계 FocusLevel

---

## Related Components

### ML & Vision
- ``FocusScorePredictor`` - ML 모델을 사용한 실시간 포커스 점수 예측
- ``FocusPersonalizater`` - 사용자 데이터를 통한 ML 모델 개인화 학습
- ``Features`` - ML 모델 입력 특성 데이터 구조
- ``UserTrainingData`` - ML 모델 학습을 위한 사용자 데이터 저장

### Analysis & Detection
- ``VisionBlinkDetector`` - Vision 프레임워크를 통한 깜빡임 감지
- ``VisionYawnDetector`` - 하품 감지
- ``FaceAbsenceTimer`` - 얼굴 이탈 시간 측정

### Utilities & System
- ``MinMaxScaler`` - 입력 데이터 정규화 유틸리티
- ``ModelLoader`` - ML 모델 로딩 및 업데이트 관리
