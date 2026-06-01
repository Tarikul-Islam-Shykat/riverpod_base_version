# Provider Wiring Notes

This note is for the Riverpod part that feels confusing at first:

- how to define a provider
- what to put inside it
- how to know which dependency it should read
- why some providers read `networkServiceProvider`, `appDbProvider`, or another provider

## Main Idea

A provider is a **wiring layer**.

It does not usually contain business logic.
It mostly says:

- create this object
- give it the objects it needs
- make it available to the rest of the app

## The Easy Rule

Look at the class constructor.

If a class needs something in its constructor, the provider should supply it.

Example:

```dart
class UserRemoteDataSource {
  UserRemoteDataSource(this._networkService);

  final NetworkService _networkService;
}
```

This tells us:

- `UserRemoteDataSource` needs `NetworkService`
- so the provider must read `networkServiceProvider`

Example provider:

```dart
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserRemoteDataSource(networkService);
});
```

## What Each Provider Usually Does

### 1. Service Provider

Creates a reusable service object.

Example:

```dart
final imageServiceProvider = Provider((ref) => ImageService());
```

Use this when the class does not depend on other providers.

### 2. Data Source Provider

Creates the class that talks to API or local database.

Example:

```dart
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserRemoteDataSource(networkService);
});
```

This provider depends on:

- `networkServiceProvider`

because the data source needs the network service.

### 3. Repository Provider

Creates the implementation that connects domain and data.

Example:

```dart
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  final localDataSource = ref.read(userLocalDataSourceProvider);
  return UserRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});
```

This provider depends on:

- `userRemoteDataSourceProvider`
- `userLocalDataSourceProvider`

because the repository implementation needs both.

### 4. Use Case Provider

Creates the domain action.

Example:

```dart
final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUsersUseCase(repository);
});
```

This provider depends on:

- `userRepositoryProvider`

because the use case calls the repository.

### 5. UI Async Provider

Creates the state that the screen watches.

Example:

```dart
final usersProvider = FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final useCase = ref.read(getUsersUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});
```

This provider depends on:

- `getUsersUseCaseProvider`

because it needs the use case to start the flow.

## How To Know What To Read

Use this checklist:

1. What class am I creating?
2. What does that class need in its constructor?
3. Do I already have a provider for those needs?
4. If yes, `ref.read(...)` it
5. Pass it into the constructor

## Example: Remote Data Source

Constructor:

```dart
UserRemoteDataSource(this._networkService)
```

Provider:

```dart
final networkService = ref.read(networkServiceProvider);
```

Reason:

- the class needs a network service

## Example: Local Data Source

Constructor:

```dart
UserLocalDataSource(this._database)
```

Provider:

```dart
final database = ref.read(appDbProvider);
```

Reason:

- the class needs the app database

## Example: Repository Implementation

Constructor:

```dart
UserRepositoryImpl({
  required UserRemoteDataSource remoteDataSource,
  required UserLocalDataSource localDataSource,
})
```

Provider:

```dart
final remoteDataSource = ref.read(userRemoteDataSourceProvider);
final localDataSource = ref.read(userLocalDataSourceProvider);
```

Reason:

- the repository needs both data sources

## Example: Use Case

Constructor:

```dart
GetUsersUseCase(this._repository)
```

Provider:

```dart
final repository = ref.read(userRepositoryProvider);
```

Reason:

- the use case needs the repository

## Example: UI Provider

This provider is usually what the screen watches:

```dart
final usersProvider = FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final useCase = ref.read(getUsersUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});
```

Reason:

- the UI should watch one provider
- that provider can trigger the whole chain

## Short Memory Version

- class constructor decides provider dependencies
- `ref.read` gets the dependency
- provider returns the created object
- `Provider` is for object creation
- `FutureProvider` is for async UI state

## In One Line

Provider wiring means:

> create the object, read its dependencies, and pass them in

