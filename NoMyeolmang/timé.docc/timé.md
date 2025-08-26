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
앱은 카메라를 통해 사용자의 얼굴을 실시간으로 모니터링하며, Vision 프레임워크의 얼굴 랜드마크 감지 기술을 사용하여 눈 깜빡임, 하품, 자세 변화 등의 미세한 행동 변화를 포착합니다. 수집된 데이터는 Core ML 모델을 통해 분석되어 집중력 점수로 변환되며, 이 점수에 따라 타이머의 속도가 자동으로 조절됩니다.

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

- ``AppCoordinator``
- ``AppDelegate``
- ``ModuleFactory``
- ``ModuleFactoryProtocol``

### Timer & Focus Management
사용자 포커스 타이머 설정 및 실행

- ``ActualTimerManager``
- ``VirtualTimerManager``
- ``TimerViewState``

### Computer Vision Analysis
실시간 사용자 행동 분석

- ``AnalysisManager``
- ``CameraManager``
- ``FaceAbsenceTimer``
- ``VisionBlinkDetector``
- ``VisionYawnDetector``

### Machine Learning Prediction
ML 모델을 활용한 집중력 예측 및 개인화

- ``Configuration``
- ``FocusLevel``
- ``MinMaxScaler``
- ``ModelLoader``
- ``Features``
- ``FocusPersonalizater``
- ``FocusScorePredictor``
- ``UserTrainingData``

### Data Layer & Persistence
데이터 저장소와 영속성 관리

- ``UserTrainingDataRepository``
- ``SwiftDataUserTrainingDataRepository``
