# Genkit + Firebase AI Logic Integration Guide

**For**: go-question project (Flutter + Dart)  
**When to use**: Building AI-powered features using Genkit flows and Gemini API  
**Strictness**: `strict` — AI/LLM integrations are security-critical

---

## Overview

Genkit is a Google framework for building AI applications with flows, tools, and structured outputs. **Firebase AI Logic** provides managed Gemini API access with security rules.

Use Genkit when you need:
- ✅ Structured AI responses (scoring logic, recommendations, classifications)
- ✅ Multi-step flows (retrieval → reasoning → summarization)
- ✅ Tool calling (AI calling backend functions)
- ✅ Rate limiting & audit trails

---

## Architecture Pattern

### Layer Integration

```
Presentation (BLoC + UI)
        ↓
Domain (AI Services interfaces, Result types)
        ↓
Data (Genkit client, flow wrappers, result mapping)
        ↓
Firebase AI Logic / Genkit (LLM inference, flows, tools)
```

**Key: Keep all Genkit/LLM calls in the data layer. BLoCs talk to service interfaces only.**

---

## Setup Steps

### 1. **Install Genkit SDK for Dart**

```bash
flutter pub add genkit

# Or add to pubspec.yaml
# genkit: ^0.2.0  # check latest
```

### 2. **Configure Firebase AI Logic**

```bash
firebase init genkit

# Follow prompts:
# - Choose project
# - Create Genkit config (creates genkit.yaml)
```

### 3. **Initialize Genkit Client**

In `lib/core/services/genkit_service.dart`:

```dart
import 'package:genkit/genkit.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeGenkit() async {
  // Initialize Genkit with Firebase
  genkit.initialize(
    projectId: 'your-firebase-project',
    location: 'us-central1',
  );
}
```

### 4. **Register in DI Container**

In `lib/injection_container/injection_container.dart`:

```dart
import 'package:go_question/core/services/genkit_service.dart';

void setupGenkitServices() {
  // Initialize first
  getIt.registerSingletonAsync<GenkitService>(
    () async => GenkitService.create(),
    signalsReady: true,
  );

  // Register AI features that depend on it
  getIt.registerSingleton<ScoringAIService>(
    ScoringAIServiceImpl(getIt<GenkitService>()),
  );
}

// In main.dart
await setupGenkitServices();
```

---

## Use Case: Scoring AI Feature

Example: AI-powered question scoring using Genkit.

### 1. Domain Layer (Contracts)

```dart
// lib/features/score/domain/services/scoring_ai_service.dart
import 'package:go_question/core/models/result.dart';

abstract class ScoringAIService {
  /// Score a user's answer based on a rubric and model response
  Future<Result<AnswerScore, ScoreFailure>> scoreAnswer({
    required String questionId,
    required String userAnswer,
    required String correctAnswer,
    required String rubric,
  });

  /// Generate feedback for a user's answer
  Future<Result<String, ScoreFailure>> generateFeedback({
    required String userAnswer,
    required String correctAnswer,
    required String explanation,
  });
}

// lib/features/score/domain/entities/answer_score.dart
import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class AnswerScore with _$AnswerScore {
  const factory AnswerScore({
    required int score,
    required int maxScore,
    required String reasoning,
  }) = _AnswerScore;
}

// lib/features/score/domain/failures/score_failure.dart
sealed class ScoreFailure extends Failure<ScoreFailure> {
  const ScoreFailure();

  factory ScoreFailure.fromException(Exception exception) {
    // Map Genkit/AI failures
    if (exception is GenkitException) {
      return ScoreFailure.aiError(exception.message ?? 'AI processing failed');
    }
    if (exception is TimeoutException) {
      return ScoreFailure.timeout();
    }
    return ScoreFailure.unknown(exception.toString());
  }

  const factory ScoreFailure.aiError(String message) = _AIError;
  const factory ScoreFailure.timeout() = _Timeout;
  const factory ScoreFailure.rateLimited() = _RateLimited;
  const factory ScoreFailure.invalidInput(String message) = _InvalidInput;
  const factory ScoreFailure.unknown(String message) = _Unknown;
}
```

### 2. Data Layer (Genkit Flows & Services)

#### Define Genkit Flow

```dart
// lib/features/score/data/genkit/scoring_flow.dart
import 'package:genkit/genkit.dart';

final scoringFlow = defineFlow<dynamic, Map<String, dynamic>>(
  name: 'score_answer',
  description: 'Score a user answer using AI evaluation',
  inputSchema: Schema(
    properties: {
      'question_id': Schema(type: 'string'),
      'user_answer': Schema(type: 'string'),
      'correct_answer': Schema(type: 'string'),
      'rubric': Schema(type: 'string'),
    },
    required: ['user_answer', 'correct_answer', 'rubric'],
  ),
  outputSchema: Schema(
    properties: {
      'score': Schema(type: 'integer'),
      'max_score': Schema(type: 'integer'),
      'reasoning': Schema(type: 'string'),
    },
  ),
  configSchema: Schema(),
  authPolicy: (auth, input) async {
    // Validate user is authenticated
    return auth.isAuthenticated ? null : Forbidden('User not authenticated');
  },
  handler: (input) async {
    final userAnswer = input['user_answer'] as String;
    final correctAnswer = input['correct_answer'] as String;
    final rubric = input['rubric'] as String;

    // Call Gemini via genkit
    final response = await genkit.generateContent(
      model: 'gemini-1.5-pro',
      prompt: _buildScoringPrompt(userAnswer, correctAnswer, rubric),
      generationConfig: GenerationConfig(
        temperature: 0.3, // Lower temperature for consistent scoring
        topK: 40,
        topP: 0.95,
        responseMimeType: 'application/json',
        responseSchema: Schema(
          properties: {
            'score': Schema(type: 'integer'),
            'max_score': Schema(type: 'integer'),
            'reasoning': Schema(type: 'string'),
          },
        ),
      ),
    );

    // Extract structured response
    return _parseScoreResponse(response.text ?? '');
  },
);

String _buildScoringPrompt(String userAnswer, String correct, String rubric) {
  return '''
You are an expert question grader. Score the following answer:

Rubric:
$rubric

User's Answer:
$userAnswer

Correct Answer:
$correct

Respond with JSON:
{
  "score": <integer 0-100>,
  "max_score": 100,
  "reasoning": "<explanation of score>"
}
''';
}

Map<String, dynamic> _parseScoreResponse(String jsonStr) {
  try {
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  } catch (e) {
    throw Exception('Failed to parse AI response: $e');
  }
}
```

#### Implement AI Service with Flow

```dart
// lib/features/score/data/services/scoring_ai_service_impl.dart
import 'package:go_question/core/models/result.dart';

class ScoringAIServiceImpl implements ScoringAIService {
  final GenkitService _genkitService;

  const ScoringAIServiceImpl(this._genkitService);

  @override
  Future<Result<AnswerScore, ScoreFailure>> scoreAnswer({
    required String questionId,
    required String userAnswer,
    required String correctAnswer,
    required String rubric,
  }) async {
    // Validate inputs
    if (userAnswer.isEmpty || correctAnswer.isEmpty) {
      return Result.failure(
        ScoreFailure.invalidInput('User and correct answers cannot be empty'),
      );
    }

    try {
      // Call Genkit flow
      final response = await scoringFlow({
        'question_id': questionId,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'rubric': rubric,
      });

      // Map response to domain entity
      final answer = AnswerScore(
        score: response['score'] as int,
        maxScore: response['max_score'] as int? ?? 100,
        reasoning: response['reasoning'] as String? ?? 'No reasoning provided',
      );

      return Result.success(answer);
    } on TimeoutException {
      return Result.failure(ScoreFailure.timeout());
    } on GenkitException catch (e) {
      return Result.failure(ScoreFailure.aiError(e.message ?? 'Unknown error'));
    } catch (e) {
      return Result.failure(ScoreFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<String, ScoreFailure>> generateFeedback({
    required String userAnswer,
    required String correctAnswer,
    required String explanation,
  }) async {
    try {
      final prompt = '''
You are a helpful tutor. Provide constructive feedback to help the student improve.

User's Answer:
$userAnswer

Correct Answer:
$correctAnswer

Topic Explanation:
$explanation

Provide concise, encouraging feedback in 2-3 sentences.
''';

      final response = await genkit.generateContent(
        model: 'gemini-1.5-flash',
        prompt: prompt,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
        ),
      );

      final feedback = response.text ?? 'Unable to generate feedback';
      return Result.success(feedback);
    } catch (e) {
      return Result.failure(ScoreFailure.fromException(e as Exception));
    }
  }
}
```

### 3. Presentation Layer (BLoC)

```dart
// lib/features/score/presentation/bloc/score_bloc.dart
part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  final ScoringAIService _scoringService;

  ScoreBloc(this._scoringService) : super(const ScoreState.initial()) {
    on<ScoreAnswerEvent>(_onScoreAnswer);
    on<GenerateFeedbackEvent>(_onGenerateFeedback);
  }

  Future<void> _onScoreAnswer(
    ScoreAnswerEvent event,
    Emitter<ScoreState> emit,
  ) async {
    emit(const ScoreState.scoring());

    final result = await _scoringService.scoreAnswer(
      questionId: event.questionId,
      userAnswer: event.userAnswer,
      correctAnswer: event.correctAnswer,
      rubric: event.rubric,
    );

    result.fold(
      (score) => emit(ScoreState.scored(score)),
      (failure) => emit(ScoreState.error(failure)),
    );
  }

  Future<void> _onGenerateFeedback(
    GenerateFeedbackEvent event,
    Emitter<ScoreState> emit,
  ) async {
    emit(const ScoreState.generatingFeedback());

    final result = await _scoringService.generateFeedback(
      userAnswer: event.userAnswer,
      correctAnswer: event.correctAnswer,
      explanation: event.explanation,
    );

    result.fold(
      (feedback) => emit(ScoreState.feedbackGenerated(feedback)),
      (failure) => emit(ScoreState.error(failure)),
    );
  }
}
```

---

## Security & Best Practices

### Input Validation

```dart
// Always validate AI service inputs
Future<Result<AnswerScore, ScoreFailure>> scoreAnswer({...}) async {
  // Validate lengths
  if (userAnswer.length > 5000) {
    return Result.failure(
      ScoreFailure.invalidInput('Answer exceeds maximum length'),
    );
  }

  if (rubric.length > 2000) {
    return Result.failure(
      ScoreFailure.invalidInput('Rubric exceeds maximum length'),
    );
  }

  // Proceed...
}
```

### Rate Limiting

```dart
// Implement client-side rate limiting
class RateLimitedScoringService implements ScoringAIService {
  final ScoringAIService _inner;
  final Map<String, DateTime> _lastCall = {};
  static const Duration _cooldown = Duration(seconds: 2);

  Future<Result<AnswerScore, ScoreFailure>> scoreAnswer({...}) async {
    final userId = getCurrentUser().id;
    final lastCall = _lastCall[userId];

    if (lastCall != null && DateTime.now().difference(lastCall) < _cooldown) {
      return Result.failure(ScoreFailure.rateLimited());
    }

    _lastCall[userId] = DateTime.now();
    return _inner.scoreAnswer(...);
  }
}
```

### Audit & Logging

```dart
// Log AI interactions (without storing sensitive data)
Future<Result<AnswerScore, ScoreFailure>> scoreAnswer({...}) async {
  final startTime = DateTime.now();
  
  try {
    final result = await _scoringService.scoreAnswer(...);
    
    // Log success (without sensitive content)
    logger.info(
      'AI scoring completed',
      {
        'questionId': questionId,
        'duration': DateTime.now().difference(startTime).inMilliseconds,
        'success': result.isSuccess,
      },
    );
    
    return result;
  } catch (e) {
    logger.error('AI scoring failed', e);
    rethrow;
  }
}
```

### Security Rules

In Firebase backend, add security rules for AI features:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /scores/{userId=**} {
      // Only authenticated users can score their own answers
      allow read, write: if request.auth != null && 
                           request.auth.uid == userId;
    }
    
    match /feedback/{feedbackId} {
      // Limit feedback generation requests
      allow read: if request.auth != null;
      allow create: if request.auth != null &&
                      request.size < 10000; // Limit prompt injection
    }
  }
}
```

---

## Testing

### Mock Genkit for Tests

```dart
// test/features/score/data/services/scoring_ai_service_test.dart
import 'package:mockito/mockito.dart';

void main() {
  group('ScoringAIService', () {
    late MockGenkitService mockGenkitService;
    late ScoringAIServiceImpl service;

    setUp(() {
      mockGenkitService = MockGenkitService();
      service = ScoringAIServiceImpl(mockGenkitService);
    });

    test('scoreAnswer returns success result with mapped score', () async {
      // Arrange
      when(mockGenkitService.generateContent(any))
          .thenAnswer((_) async => MockResponse(text: '{"score": 85, "max_score": 100, "reasoning": "Good answer"}'));

      // Act
      final result = await service.scoreAnswer(
        questionId: '1',
        userAnswer: 'The capital of France is Paris',
        correctAnswer: 'Paris',
        rubric: 'Exact match: 100 points',
      );

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull()?.score, 85);
    });

    test('scoreAnswer returns failure on timeout', () async {
      when(mockGenkitService.generateContent(any))
          .thenThrow(TimeoutException('API timeout'));

      final result = await service.scoreAnswer(
        questionId: '1',
        userAnswer: 'Test',
        correctAnswer: 'Test',
        rubric: 'Test',
      );

      expect(result.isFailure, true);
      expect(result.getErrorOrNull(), isA<ScoreFailure>());
    });

    test('scoreAnswer rejects empty answers', () async {
      final result = await service.scoreAnswer(
        questionId: '1',
        userAnswer: '',
        correctAnswer: 'Answer',
        rubric: 'Rubric',
      );

      expect(result.isFailure, true);
      expect(result.getErrorOrNull(), isA<ScoreFailure>());
    });
  });
}
```

### BLoC Tests

```dart
// test/features/score/presentation/bloc/score_bloc_test.dart
void main() {
  group('ScoreBloc', () {
    late MockScoringAIService mockService;
    late ScoreBloc bloc;

    setUp(() {
      mockService = MockScoringAIService();
      bloc = ScoreBloc(mockService);
    });

    test_emit_loading_then_scored_on_success() async {
      final score = AnswerScore(score: 85, maxScore: 100, reasoning: 'Good');
      
      when(mockService.scoreAnswer(...))
          .thenAnswer((_) async => Result.success(score));

      expect(
        bloc.stream,
        emitsInOrder([
          isA<ScoringState>(),
          isA<ScoredState>(),
        ]),
      );

      bloc.add(ScoreAnswerEvent(...));
    }
  });
}
```

---

## Deployment Checklist

- [ ] Genkit initialized in main.dart  
- [ ] GenkitService registered in DI
- [ ] AI service interfaces defined in domain
- [ ] Genkit flows implemented in data layer
- [ ] Input validation prevents prompt injection
- [ ] Rate limiting configured
- [ ] Error handling maps all Genkit failures
- [ ] BLoC tests passing for score + feedback flows
- [ ] Security rules configured
- [ ] Audit logging implemented
- [ ] Firebase project has Gemini API enabled
- [ ] Cost estimation completed (Genkit has pricing)

---

## References

- [Genkit Docs](https://github.com/googleapis/genkit)
- [Firebase AI Logic](https://firebase.google.com/docs/genkit)
- [Gemini API](https://ai.google.dev/)
- Project: [.agents/rules/security.md](../../.agents/rules/security.md)
- Project: [.agents/harness/10_architecture_guardrails.md](../../.agents/harness/10_architecture_guardrails.md)

---

**Last updated**: 2026-04-08
