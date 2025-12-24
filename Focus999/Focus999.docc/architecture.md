# Architecture Guide
Layered Architecture with MVVM, Manager, and Service Patterns

## Overview

timé는 **4계층 아키텍처**를 기반으로 설계되었습니다. **Presentation**, **Manager**, **Service**, **Data** 레이어를 통해 관심사를 명확히 분리하고, 각 레이어가 단일 책임을 가지도록 구성했습니다.

![4-Layer Architecture](architecture-diagram.svg "SwiftUI 4계층 아키텍처")

### Architecture Philosophy

- **점진적 복잡성 관리**: ViewModel에서 시작하여 필요에 따라 Service → Manager로 자연스럽게 분리
- **단일 책임 원칙**: 각 클래스는 하나의 명확한 책임만 가집니다
- **레이어별 분리**: 상위 레이어는 하위 레이어에만 의존합니다

---

## Architecture Layers

### Presentation Layer

**책임**: UI 상태 관리와 사용자 입력 처리

#### 비즈니스 로직 분리 전략

**1단계: ViewModel 내 로직 시작**
```swift
@MainActor
final class TimerViewModel: ObservableObject {
    @Published var formattedTime: String = "30:00"
    @Published var sessionState: TimerViewState = .idle
    
    // 초기에는 ViewModel에서 직접 처리
    func startSession() {
        sessionState = .isRunning
        // 간단한 비즈니스 로직 포함 가능
    }
}
```

**2단계: 복잡해지면 Service로 분리**
```swift
@MainActor
final class TimerViewModel: ObservableObject {
    @Published var formattedTime: String = "30:00"
    @Published var sessionState: TimerViewState = .idle
    
    private let timerService: TimerService  // 비즈니스 로직 분리
    
    func startSession() {
        sessionState = .isRunning
        timerService.start()  // Service에게 위임
    }
}
```

**3단계: 여러 Service가 필요하면 Manager 도입**
```swift
@MainActor
final class TimerViewModel: ObservableObject {
    @Published var formattedTime: String = "30:00"
    @Published var sessionState: TimerViewState = .idle
    
    private let sessionManager: SessionManager  // 여러 Service를 조율하는 Manager
    
    func startSession() {
        sessionState = .isRunning
        sessionManager.startSession()  // Manager가 복잡한 조율 담당
    }
}
```

> Note: ViewModel은 "무엇을 할지"만 결정하고, "어떻게 할지"는 비즈니스 로직의 복잡도에 따라 Service 또는 Manager가 담당합니다.

---

### Manager Layer

**책임**: 도메인별 복잡한 로직 관리 및 여러 Service 통합

#### 실제 구현 예시

```swift
final class AnalysisManager {
    // 여러 Vision 서비스들을 통합 관리
    private let blinkDetector = VisionBlinkDetector()
    private let yawnDetector = VisionYawnDetector()
    private let faceTimer = FaceAbsenceTimer()
    
    // 복잡한 Vision 분석 플로우 관리
    func analyze(pixelBuffer: CVPixelBuffer) {
        let request = VNDetectFaceLandmarksRequest()
        // Vision 요청 수행 후 각 서비스에 분배
        blinkDetector.detect(from: landmarks)
        yawnDetector.detect(from: landmarks)
        faceTimer.update(isFacePresent: hasValidFace)
    }
    
    // 여러 서비스 결과를 통합
    func generateFeatures() -> Features {
        return Features(
            blinkCountPerMin: blinkDetector.totalCount,
            yawnPerMin: yawnDetector.totalCount,
            faceBodyPresent: faceTimer.totalAbsenceTime
        )
    }
}
```

---

### Service Layer

**책임**: 단일 기능에 집중하는 재사용 가능한 컴포넌트

#### 설계 원칙

- **Single Responsibility**: 하나의 기능만 완벽하게 수행
- **Stateless Preferred**: 가능한 한 내부 상태를 최소화
- **Protocol-Based**: 인터페이스를 통한 추상화

#### 예시: Vision Analysis Services

```swift
// 눈 깜빡임만 전문으로 처리
final class VisionBlinkDetector: BlinkDetector {
    private var blinkCount = 0
    private let earThreshold: CGFloat = 0.18
    
    func detect(from landmarks: VNFaceLandmarks2D?) -> Int {
        // EAR 알고리즘으로 깜빡임 감지
        let ear = calculateEyeAspectRatio(landmarks)
        // 깜빡임 판정 로직
        return blinkCount
    }
}
```

---

### Data Layer

**책임**: 데이터 영속성 및 CRUD 작업

#### Repository Pattern

```swift
// 프로토콜로 추상화
protocol UserTrainingDataRepository {
    func write(input data: [UserTrainingData]) async throws -> Bool
    func fetch(count: Int) async throws -> [UserTrainingData]
    func update(to newScore: Double, count: Int) async throws -> Bool
    func clear() async throws -> Bool
}

// SwiftData 구현체
final class SwiftDataUserTrainingDataRepository: UserTrainingDataRepository {
    private let context: ModelContext
    
    func write(input data: [UserTrainingData]) async throws -> Bool {
        for item in data {
            context.insert(item)
        }
        try context.save()
        return true
    }
}
```

---

## 실용적 가이드라인

### 분리 기준

1. **ViewModel → Service**: 비즈니스 로직이 10줄 이상이거나 복잡한 계산 포함
2. **Service → Manager**: 3개 이상의 Service 조율이 필요하거나 복잡한 플로우 존재
3. **Manager 내부**: Service들 간의 의존성과 실행 순서를 관리

### Layer Communication Rules

- **Downward Dependency**: 상위 → 하위 레이어만 직접 호출
- **Upward Communication**: 콜백, Delegate, Publisher로 상위에 알림
- **Cross-Layer Prohibition**: 동일 레벨 간 직접 의존 금지

> **Important**: 레이어를 건너뛰는 직접 호출은 금지됩니다. (예: ViewModel → Service 직접 호출)

### Common Anti-Patterns

❌ **Fat ViewModel**: ViewModel에 비즈니스 로직 포함
❌ **Layer Skipping**: 레이어 건너뛰기  
❌ **God Manager**: 모든 것을 담당하는 거대한 Manager

> **Tip**: 각 클래스가 한 문장으로 설명될 수 있다면 잘 설계된 것입니다.

---

## Topics

### Architecture Layers
- ``TimerViewModel``
- ``FeedbackViewModel``
- ``ReportViewModel``
- ``TimerSettingViewModel``

### Manager Layer Components
- ``AnalysisManager``
- ``ActualTimerManager``
- ``VirtualTimerManager``
- ``CameraManager``

### Service Layer Components
- ``VisionBlinkDetector``
- ``VisionYawnDetector``
- ``FaceAbsenceTimer``
- ``FocusScorePredictor``
- ``FocusPersonalizater``

### Data Layer Components
- ``UserTrainingDataRepository``
- ``SwiftDataUserTrainingDataRepository``

### Dependency Injection
- ``ModuleFactory``
- ``ModuleFactoryProtocol``
