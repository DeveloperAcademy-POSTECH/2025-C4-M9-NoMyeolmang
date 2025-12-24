# Dual-Timer
Understanding the Dual-Timer System and Focus Integration

## Overview

timé의 핵심 혁신은 **이중 타이머 시스템**입니다. 실제 시간을 추적하는 ``ActualTimerManager``와 집중도에 따라 속도가 변하는 ``VirtualTimerManager``가 동시에 작동하여, 사용자의 몰입 상태를 시각적으로 체감할 수 있게 합니다.

![Dual-Timer System](timer-system-diagram.svg "이중 타이머 시스템 아키텍처")

``TimerViewModel``이 세션 시작 시 두 타이머를 동시에 초기화합니다. ``ActualTimerManager``는 사용자가 설정한 목표 시간(예: 30분)을 정확히 카운트다운하며, ``VirtualTimerManager``는 동일한 시간에서 시작하지만 ``FocusLevel``에 따라 속도가 실시간으로 변합니다.

``AnalysisManager``에서 분석된 집중도 데이터가 ``FocusScorePredictor``를 통해 0.0-5.0 점수로 변환되면, ``FocusLevel.from(rawValue:)``가 이를 5단계 레벨로 분류합니다. 각 ``FocusLevel``의 ``tickSpeed()`` 값이 ``VirtualTimerManager``의 간격을 조절하여, 집중도가 높을 때(lv5)는 2배 빠르게, 낮을 때(lv1)는 절반 속도로 흐르게 합니다.

두 타이머의 차이는 **몰입의 가치**를 시각화합니다. 집중할 때 얻는 시간의 이득과 산만할 때 잃는 시간의 손실을 명확히 보여주어, 사용자에게 자연스러운 집중 동기를 제공합니다.

## Topics

### Timer Components
- ``ActualTimerManager``
- ``VirtualTimerManager``
- ``TimerViewModel``
- ``TimerViewState``

### Focus Integration
- ``FocusLevel``
- ``FocusScorePredictor``
- ``Features``

### Session Management
- Session lifecycle and state transitions
- Real-time analysis integration
- Performance optimization strategies
