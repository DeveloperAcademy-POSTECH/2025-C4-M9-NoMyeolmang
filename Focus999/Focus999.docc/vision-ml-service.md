# Vision & ML
Analyzing User Focus with Vision and Machine Learning

## Overview

timé의 Vision & ML 시스템은 실시간 비디오 분석과 머신러닝을 통합하여 사용자 집중도를 예측합니다.

![Vision-ML Pipeline](vision-ml-pipeline-flow-diagram.svg "Vision-ML 데이터 처리 파이프라인")


``CameraManager``에서 캡처된 비디오 프레임은 ``AnalysisManager``로 전달되어 Vision 기반 행동 분석이 수행됩니다. 분석 결과는 ``Features`` 구조체로 정리되고, ``FocusScorePredictor``를 통해 집중도 점수로 변환됩니다.

예측된 점수는 ``FocusLevel``로 분류되어 타이머 시스템에 적용되며, 동시에 ``UserTrainingData``로 저장됩니다. ``FocusPersonalizater``는 축적된 사용자 데이터를 활용하여 모델을 지속적으로 개선합니다.

이러한 Vision-ML 파이프라인을 통해 시스템은 각 사용자에게 맞춤화된 집중도 분석을 제공합니다.

## Topics

### Capturing Video Frames
- ``CameraManager``

### Analyzing User Behavior
- ``AnalysisManager``
- ``VisionBlinkDetector``
- ``VisionYawnDetector``
- ``FaceAbsenceTimer``

### Predicting Focus Scores
- ``FocusScorePredictor``
- ``Features``
- ``FocusLevel``

### Personalizing Models
- ``FocusPersonalizater``
- ``UserTrainingData``

### Managing Model Resources
- ``ModelLoader``
- ``Configuration``
- ``MinMaxScaler``
