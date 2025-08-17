# ``timé``

실시간 집중력 분석 타이머 앱

## Overview

timé는 Vision, Tabular ML 기술을 활용하여 사용자의 집중력을 실시간으로 분석하고, 그 결과에 따라 타이머의 속도를 동적으로 조절하는 포커스 타이머 앱입니다.

### Core Features
- **집중 타이머**: ML 모델이 예측한 집중력에 따라 시간이 빠르게 또는 느리게 흐름
- **현실 타이머**: 사용자가 설정한 실제 시간을 정확하게 표시
- **실시간 모니터링**: Vision 프레임워크를 통한 눈 깜빡임, 하품, 자세 변화 등 행동 분석
- **개인화 학습**: 사용자별 행동 패턴을 학습하여 점진적으로 정확도 향상

### How It Works
앱은 카메라를 통해 사용자의 얼굴을 실시간으로 모니터링하며, Vision 프레임워크의 얼굴 랜드마크 감지 기술을 사용하여 눈 깜빡임, 하품, 자세 변화 등의 미세한 행동 변화를 포착합니다. 수집된 데이터는 Core ML 모델을 통해 분석되어 0.0~1.0 사이의 집중력 점수로 변환되며, 이 점수에 따라 타이머의 속도가 자동으로 조절됩니다.

### Key Benefits
집중력이 높을 때는 시간이 빠르게 흐르는 것을 느끼게 하여 몰입감을 증진시키고, 집중력이 떨어질 때는 시간이 느리게 흐르는 것을 통해 사용자가 자신의 상태를 인지하고 다시 집중할 수 있도록 돕습니다. 두 타이머의 차이를 통해 몰입의 가치를 시각적으로 체감할 수 있습니다.

---

## Technology

- **Core ML**: 실시간 포커스 점수 예측
- **Vision**: 얼굴 랜드마크 감지 및 행동 분석
- **AVFoundation**: 카메라 캡처 및 실시간 스트림
- **SwiftData**: 로컬 데이터 저장소
- **SwiftUI**: UI 프레임워크

---

## Development Environment

- **Swift**: 5.0+ (Swift 6.0.3에서 개발됨)
- **Xcode**: 16.4+
- **Platform**: macOS 13.0+

---

## Availability

- **macOS**: 13.0+
- **iOS**: 17.0+
- **iPadOS**: 17.0+

## Topics

### App Architecture & Navigation
앱의 전체 구조와 화면 전환

- ``AppCoordinator`` - 화면 전환 및 네비게이션 관리
- ``AppDelegate`` - 앱 생명주기 및 시스템 이벤트 관리
- ``ModuleFactory`` - 의존성 주입 및 모듈 생성
- ``ModuleFactoryProtocol`` - 모듈 팩토리 프로토콜

### Timer & Focus Management
사용자 포커스 타이머 설정 및 실행

- ``ActualTimerManager`` - 실제 시간 타이머 관리
- ``VirtualTimerManager`` - 가상 시간 타이머 관리
- ``TimerViewState`` - 타이머 뷰 상태 정의

### Computer Vision Analysis
실시간 사용자 행동 분석

- ``AnalysisManager`` - Vision 분석 데이터 통합
- ``CameraManager`` - 카메라 시스템 및 비디오 스트림 관리
- ``FaceAbsenceTimer`` - 자리 이탈 감지
- ``VisionBlinkDetector`` - 깜빡임 감지
- ``VisionYawnDetector`` - 하품 감지

### Machine Learning Prediction
ML 모델을 활용한 집중력 예측 및 개인화

- ``Configuration`` - ML 모델 설정 및 경로 관리
- ``FocusLevel`` - 집중력 수준 정의
- ``MinMaxScaler`` - 입력 데이터 정규화 유틸리티
- ``ModelLoader`` - ML 모델 로딩 및 업데이트 관리
- ``Features`` - ML 모델 입력 특성 데이터 구조
- ``FocusPersonalizater`` - 사용자 데이터를 통한 ML 모델 개인화 학습
- ``FocusScorePredictor`` - ML 모델을 사용한 실시간 포커스 점수 예측
- ``UserTrainingData`` - ML 모델 학습을 위한 사용자 데이터 저장

### Data Layer & Persistence
데이터 저장소와 영속성 관리

- ``UserTrainingDataRepository`` - ML 학습 데이터 저장소 프로토콜
- ``SwiftDataUserTrainingDataRepository`` - SwiftData 기반 Repository 구현체
