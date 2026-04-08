# Firebase Data Connect Integration Guide

**For**: go-question project using BLoC + Flutter  
**When to use**: Building relational data backends with GraphQL  
**Strictness**: `strict` — Data contracts are foundational

---

## Overview

Firebase Data Connect provides a managed, PostgreSQL-backed GraphQL API that integrates seamlessly with Flutter. It's ideal for complex relational data (users, events, friends, scores, etc.) that Firebase Firestore struggles to query efficiently.

### When to Choose Data Connect vs Firestore

| Use Firestore | Use Data Connect |
|---|---|
| Simple document storage | Complex relational queries |
| Real-time listeners | Batch/pagination needs |
| Offline priority | Structured multi-table data |
| Key-value semantics | ACID transactions needed |

For **go-question** (users → friends → events → scores), Data Connect may be the optimal choice.

---

## Architecture Pattern

### Layer Integration

```
Presentation (BLoC + UI)
        ↓
Domain (Repository interfaces, Entities, Result types)
        ↓
Data (GraphQL client, mappers, repository implementations)
        ↓
Firebase Data Connect (PostgreSQL + GraphQL API)
```

**Key: Data layer owns ALL Data Connect SDK calls. Never call Data Connect from BLoC or UI.**

---

## Setup Steps

### 1. **Enable Firebase Data Connect**

```sh
firebase init dataconnect

# Follow prompts:
# - Choose project
# - PostgreSQL version
# - Accept default schema location (firebase/firestore.gql)
```

### 2. **Define GraphQL Schema**

Create `firebase/firestore.gql`:

```graphql
# Example: Users and Friends
type User {
  id: UUID!
  email: String!
  displayName: String!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Friend {
  id: UUID!
  userId: UUID!
  friendId: UUID!
  status: FriendStatus!
  createdAt: DateTime!
}

enum FriendStatus {
  PENDING
  ACCEPTED
  BLOCKED
}

# Queries
extend type Query {
  getUserById(id: UUID!): User
  listFriends(userId: UUID!, limit: Int = 10, offset: Int = 0): [Friend!]!
}

# Mutations
extend type Mutation {
  createFriend(userId: UUID!, friendId: UUID!): Friend!
  updateFriendStatus(friendId: UUID!, status: FriendStatus!): Friend!
}
```

### 3. **Generate Dart SDK**

```bash
# After schema is deployed to PostgreSQL
firebase dataconnect:generate --in-process

# Generates:
# - lib/generated/data_connect_generated/*
# - Type-safe GraphQL client wrappers
```

### 4. **Configure Project-Level DI**

In `lib/injection_container/injection_container.dart`:

```dart
import 'package:generated_data_connect/lib/data_connect.dart';

void setupDataConnect() {
  // Initialize Data Connect client
  final dataConnectClient = FirebaseDataConnect.instance;
  
  // Register in GetIt
  getIt.registerSingleton<FirebaseDataConnect>(dataConnectClient);
  
  // Register data sources that use it
  getIt.registerSingleton<FriendsDataSource>(
    FriendsDataSourceImpl(dataConnectClient),
  );
}
```

---

## Domain Layer (Contracts)

### Entities (Immutable)

```dart
// lib/features/friends/domain/entities/friend.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend.freezed.dart';

@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String userId,
    required String friendId,
    required FriendStatus status,
    required DateTime createdAt,
  }) = _Friend;
}

enum FriendStatus { pending, accepted, blocked }
```

### Failures

```dart
// lib/features/friends/domain/failures/friend_failure.dart
import 'package:go_question/core/failures/failure.dart';

sealed class FriendFailure extends Failure<FriendFailure> {
  const FriendFailure();

  factory FriendFailure.fromException(Exception exception) {
    // Map Data Connect-specific exceptions
    if (exception is FirebaseDataConnectException) {
      return FriendFailure.networkError(exception.message ?? 'Network error');
    }
    return FriendFailure.unknown(exception.toString());
  }

  const factory FriendFailure.networkError(String message) = _NetworkError;
  const factory FriendFailure.notFound() = _NotFound;
  const factory FriendFailure.permissionDenied() = _PermissionDenied;
  const factory FriendFailure.unknown(String message) = _Unknown;
}

class _NetworkError extends FriendFailure {
  final String message;
  const _NetworkError(this.message);
}

class _NotFound extends FriendFailure {
  const _NotFound();
}

class _PermissionDenied extends FriendFailure {
  const _PermissionDenied();
}

class _Unknown extends FriendFailure {
  final String message;
  const _Unknown(this.message);
}
```

### Repository Interface

```dart
// lib/features/friends/domain/repositories/friends_repository.dart
import 'package:go_question/core/models/result.dart';

abstract class FriendsRepository {
  Future<Result<Friend, FriendFailure>> getFriendById(String friendId);
  
  Future<Result<List<Friend>, FriendFailure>> listUserFriends(
    String userId, {
    int limit = 10,
    int offset = 0,
  });

  Future<Result<Friend, FriendFailure>> createFriendRequest(
    String userId,
    String friendId,
  );

  Future<Result<Friend, FriendFailure>> updateFriendStatus(
    String friendId,
    FriendStatus newStatus,
  );
}
```

---

## Data Layer (Implementations)

### GraphQL DTOs (Auto-mapped from Data Connect)

Data Connect generates these automatically. Example:

```dart
// lib/features/friends/data/models/friend_dto.dart
// Auto-generated
@JsonSerializable()
class FriendDTO {
  final String id;
  final String userId;
  final String friendId;
  final String status;
  final DateTime createdAt;

  FriendDTO({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status,
    required this.createdAt,
  });

  factory FriendDTO.fromJson(Map<String, dynamic> json) => _$FriendDTOFromJson(json);
}
```

### DataSource (Calls Data Connect)

```dart
// lib/features/friends/data/datasources/friends_datasource.dart
import 'generated_data_connect/lib/data_connect.dart';

abstract class FriendsDataSource {
  Future<FriendDTO> getFriendById(String friendId);
  Future<List<FriendDTO>> listUserFriends(String userId, {int limit, int offset});
  Future<FriendDTO> createFriendRequest(String userId, String friendId);
  Future<FriendDTO> updateFriendStatus(String friendId, String newStatus);
}

class FriendsDataSourceImpl implements FriendsDataSource {
  final FirebaseDataConnect _dataConnect;

  FriendsDataSourceImpl(this._dataConnect);

  @override
  Future<FriendDTO> getFriendById(String friendId) async {
    // Use generated Data Connect client
    final response = await _dataConnect.query(
      GetUserByIdQuery(friendId: friendId),
    );
    
    if (response.data == null) {
      throw FirebaseDataConnectException('Friend not found');
    }
    
    return FriendDTO.fromJson(response.data!.toJson());
  }

  @override
  Future<List<FriendDTO>> listUserFriends(
    String userId, {
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await _dataConnect.query(
      ListFriendsQuery(
        userId: userId,
        limit: limit,
        offset: offset,
      ),
    );

    if (response.data?.friends == null) return [];
    
    return response.data!.friends
        .map((f) => FriendDTO.fromJson(f.toJson()))
        .toList();
  }

  @override
  Future<FriendDTO> createFriendRequest(String userId, String friendId) async {
    final response = await _dataConnect.mutate(
      CreateFriendMutation(userId: userId, friendId: friendId),
    );

    if (response.data == null) {
      throw FirebaseDataConnectException('Failed to create friend request');
    }

    return FriendDTO.fromJson(response.data!.toJson());
  }

  @override
  Future<FriendDTO> updateFriendStatus(String friendId, String newStatus) async {
    final response = await _dataConnect.mutate(
      UpdateFriendStatusMutation(friendId: friendId, status: newStatus),
    );

    if (response.data == null) {
      throw FirebaseDataConnectException('Failed to update friend status');
    }

    return FriendDTO.fromJson(response.data!.toJson());
  }
}
```

### Mapper (DTO → Entity)

```dart
// lib/features/friends/data/mappers/friend_mapper.dart
import 'package:go_question/features/friends/domain/entities/friend.dart';

class FriendMapper {
  static Friend toDomain(FriendDTO dto) {
    return Friend(
      id: dto.id,
      userId: dto.userId,
      friendId: dto.friendId,
      status: _mapStatus(dto.status),
      createdAt: dto.createdAt,
    );
  }

  static FriendStatus _mapStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'pending':
        return FriendStatus.pending;
      case 'accepted':
        return FriendStatus.accepted;
      case 'blocked':
        return FriendStatus.blocked;
      default:
        return FriendStatus.pending;
    }
  }
}
```

### Repository Implementation

```dart
// lib/features/friends/data/repositories/friends_repository_impl.dart
import 'package:go_question/core/models/result.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsDataSource _dataSource;

  FriendsRepositoryImpl(this._dataSource);

  @override
  Future<Result<Friend, FriendFailure>> getFriendById(String friendId) async {
    try {
      final dto = await _dataSource.getFriendById(friendId);
      return Result.success(FriendMapper.toDomain(dto));
    } catch (e) {
      return Result.failure(FriendFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<Friend>, FriendFailure>> listUserFriends(
    String userId, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final dtos = await _dataSource.listUserFriends(
        userId,
        limit: limit,
        offset: offset,
      );
      return Result.success(
        dtos.map(FriendMapper.toDomain).toList(),
      );
    } catch (e) {
      return Result.failure(FriendFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<Friend, FriendFailure>> createFriendRequest(
    String userId,
    String friendId,
  ) async {
    try {
      final dto = await _dataSource.createFriendRequest(userId, friendId);
      return Result.success(FriendMapper.toDomain(dto));
    } catch (e) {
      return Result.failure(FriendFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<Friend, FriendFailure>> updateFriendStatus(
    String friendId,
    FriendStatus newStatus,
  ) async {
    try {
      final dto = await _dataSource.updateFriendStatus(
        friendId,
        newStatus.toString().split('.').last,
      );
      return Result.success(FriendMapper.toDomain(dto));
    } catch (e) {
      return Result.failure(FriendFailure.fromException(e as Exception));
    }
  }
}
```

---

## Presentation Layer (BLoC)

```dart
// lib/features/friends/presentation/bloc/friends_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsRepository _repository;

  FriendsBloc(this._repository) : super(const FriendsState.initial()) {
    on<FetchFriendsEvent>(_onFetchFriends);
    on<UpdateFriendStatusEvent>(_onUpdateFriendStatus);
  }

  Future<void> _onFetchFriends(
    FetchFriendsEvent event,
    Emitter<FriendsState> emit,
  ) async {
    emit(const FriendsState.loading());
    
    final result = await _repository.listUserFriends(
      event.userId,
      limit: event.limit,
      offset: event.offset,
    );

    result.fold(
      (friends) => emit(FriendsState.success(friends)),
      (failure) => emit(FriendsState.error(failure)),
    );
  }

  Future<void> _onUpdateFriendStatus(
    UpdateFriendStatusEvent event,
    Emitter<FriendsState> emit,
  ) async {
    final result = await _repository.updateFriendStatus(
      event.friendId,
      event.newStatus,
    );

    result.fold(
      (updatedFriend) {
        // Handle state update (e.g., update list)
        emit(FriendsState.success([updatedFriend]));
      },
      (failure) => emit(FriendsState.error(failure)),
    );
  }
}
```

---

## Testing

### Test DataSource (Mock Data Connect)

```dart
// test/features/friends/data/datasources/friends_datasource_test.dart
import 'package:mockito/mockito.dart';

void main() {
  group('FriendsDataSource', () {
    late MockFirebaseDataConnect mockDataConnect;
    late FriendsDataSourceImpl dataSource;

    setUp(() {
      mockDataConnect = MockFirebaseDataConnect();
      dataSource = FriendsDataSourceImpl(mockDataConnect);
    });

    test('getFriendById returns FriendDTO on success', () async {
      // Arrange
      final mockDTO = FriendDTO(
        id: '1',
        userId: 'user1',
        friendId: 'user2',
        status: 'accepted',
        createdAt: DateTime.now(),
      );
      
      when(mockDataConnect.query(any))
          .thenAnswer((_) async => MockDataConnectResponse(data: mockDTO));

      // Act
      final result = await dataSource.getFriendById('1');

      // Assert
      expect(result.id, '1');
      verify(mockDataConnect.query(any)).called(1);
    });

    test('getFriendById throws on network error', () async {
      when(mockDataConnect.query(any))
          .thenThrow(FirebaseDataConnectException('Network error'));

      expect(
        () => dataSource.getFriendById('1'),
        throwsA(isA<FirebaseDataConnectException>()),
      );
    });
  });
}
```

### Test Repository (Verify Mapping & Error Handling)

```dart
// test/features/friends/data/repositories/friends_repository_test.dart
void main() {
  group('FriendsRepository', () {
    late FriendsRepositoryImpl repository;

    setUp(() {
      final mockDataSource = MockFriendsDataSource();
      repository = FriendsRepositoryImpl(mockDataSource);
    });

    test('listUserFriends returns success Result with mapped entities', () async {
      // Arrange
      final mockDTOs = [
        FriendDTO(...),
      ];
      
      when(mockDataSource.listUserFriends(any, limit: anyNamed('limit')))
          .thenAnswer((_) async => mockDTOs);

      // Act
      final result = await repository.listUserFriends('user1');

      // Assert
      expect(result.isSuccess, true);
      expect(result.getOrNull(), isA<List<Friend>>());
    });

    test('listUserFriends returns failure Result on exception', () async {
      when(mockDataSource.listUserFriends(any, limit: anyNamed('limit')))
          .thenThrow(Exception('Network error'));

      final result = await repository.listUserFriends('user1');

      expect(result.isFailure, true);
      expect(result.getErrorOrNull(), isA<FriendFailure>());
    });
  });
}
```

---

## Security Considerations

- ✅ **Authorization**: Use Data Connect security rules to enforce user ownership
- ✅ **Queries**: Always validate query inputs before sending to Data Connect
- ✅ **Rate limiting**: Implement client-side pagination (limit/offset)
- ❌ **Secrets**: Never hardcode API keys; use Firebase project setup
- ❌ **Raw data**: Always map DTOs to domain entities before crossing layer boundary

---

## Deployment Checklist

- [ ] Schema defined and matches domain entities
- [ ] GraphQL queries/mutations tested in Firepad console
- [ ] Data layer fully implemented with exception mapping
- [ ] Domain repository interface locked and stable
- [ ] BLoC tests passing for critical flows
- [ ] Security rules configured in Firebase backend
- [ ] Pagination working (limit/offset pattern)
- [ ] Error states properly handled in presentation

---

## References

- [Firebase Data Connect Docs](https://firebase.google.com/docs/dataconnect)
- [GraphQL Best Practices](https://graphql.org/learn/)
- Project: [.agents/rules/patterns.md](../../.agents/rules/patterns.md)
- Project: [.agents/harness/10_architecture_guardrails.md](../../.agents/harness/10_architecture_guardrails.md)

---

**Last updated**: 2026-04-08
