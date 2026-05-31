# Get User Feature

This folder is a working checklist for building a single feature step by step.

Goal:
- learn feature-based development
- keep Riverpod usage simple
- separate UI, domain, and data clearly
- make it easy for another agent to continue the work later

## What I Am Mostly Trying To Understand

I want to connect the dots between:
- where the API call happens
- who returns the data
- why the domain and data layers are separate
- how Riverpod providers depend on each other
- which provider the UI actually watches

See also:
- [`connection_flow.md`](connection_flow.md)

## Connecting The Dots

Very simply:

```text
UI
-> usersProvider
-> getUsersUseCaseProvider
-> userRepositoryProvider
-> userRemoteDataSourceProvider
-> NetworkService
-> API
```

What each part means:
- `usersProvider` is the one the UI watches
- `getUsersUseCaseProvider` gives the feature action
- `userRepositoryProvider` gives the repository implementation
- `userRemoteDataSourceProvider` makes the API call
- `NetworkService` performs the HTTP request
- the API returns JSON
- the model turns JSON into Dart objects
- the repository turns models into entities
- the use case returns the final result to the UI

This is the main thing I want to understand while building the feature step by step.

## First Folder To Build

Start with:

```text
lib/features/example/get-user-feature/domain/entities
```

Why start here:
- it defines what a `User` means in the app
- it helps me understand the feature shape before API or UI work
- it keeps the rest of the architecture clear

## Suggested First Step

For this API, it is better to start simple first:

- create `UserEntity`
- keep only the main fields at first
- add nested objects later if needed

Recommended first fields:
- `id`
- `name`
- `username`
- `email`
- `phone`
- `website`

Later, if needed, I can add:
- `address`
- `company`

## Feature Goal

Build a `GET` feature for user data using the same architecture style as the posts feature:

- `presentation` for UI and Riverpod state
- `domain` for business logic and contracts
- `data` for API calls, models, and repository implementation

## What I Should Build

### 1. Create the folder structure

Check that the feature is organized like this:

```text
lib/features/example/get-user-feature/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    pages/
    providers/
```

### 2. Define the entity

Create the clean app object for a user.

Checklist:
- [x] decide what fields a user needs
- [x] keep it independent from JSON
- [x] use it in domain and UI

Done:
- [`user_entity.dart`](domain/entities/user_entity.dart)

### 3. Define the repository contract

Create the abstract repository in the domain layer.

Checklist:
- [x] write what the feature can do
- [x] return `Either<Failure, ...>`
- [x] do not put API code here

Done:
- [`user_repository.dart`](domain/repositories/user_repository.dart)

### 4. Create the use case

Create the feature action.

Checklist:
- [x] make one use case for one action
- [x] keep business logic here
- [x] add rules like filtering, sorting, limiting, or validation if needed

Done:
- [`get_users_use_case.dart`](domain/usecases/get_users_use_case.dart)

### 5. Create the model

Create the API response model in the data layer.

Checklist:
- [x] map JSON into Dart
- [x] keep API shape separate from entity shape
- [x] add `fromJson`

Done:
- [`user_model.dart`](data/models/user_model.dart)

### 6. Create the remote data source

This is where the API call happens.

Checklist:
- [x] call the endpoint
- [x] use `NetworkService`
- [x] convert the raw response into models
- [x] log request/response if needed

Done:
- [`user_remote_data_source.dart`](data/datasources/user_remote_data_source.dart)

### 7. Create the repository implementation

This connects the domain contract to the data source.

Checklist:
- [x] implement the repository interface
- [x] convert models into entities
- [x] keep domain clean

Done:
- [`user_repository_impl.dart`](data/repositories/user_repository_impl.dart)

### 8. Create Riverpod providers

This is the wiring layer.

Checklist:
- [x] create a provider for the remote data source
- [x] create a provider for the repository
- [x] create a provider for the use case
- [x] create a `FutureProvider` or `StreamProvider` for the UI

Done:
- [`user_provider.dart`](presentation/providers/user_provider.dart)

### 9. Create the screen

The screen should only watch the provider and render state.

Checklist:
- [x] show loading state
- [x] show error state
- [x] show success state
- [x] use shared text widgets if needed

Done:
- [`users_page.dart`](presentation/pages/users_page.dart)

### 10. Connect routing

Add a route so the feature can be opened from the app.

Checklist:
- add the screen to GoRouter
- add a button or link from the home page
- test navigation

## Build Order

If I start from scratch, I should build in this order:

1. Entity
2. Repository contract
3. Use case
4. Model
5. Remote data source
6. Repository implementation
7. Providers
8. UI page
9. Route
10. Documentation

## Why This Order Works

This order helps because:

- the core data shape comes first
- the business action comes next
- the API layer stays separate
- the UI comes last
- debugging becomes easier

## Riverpod Reminder

Use Riverpod to connect the layers, not to mix them together.

Common pattern:

```dart
final userRemoteDataSourceProvider = Provider((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserRemoteDataSource(networkService);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource);
});

final getUserUseCaseProvider = Provider((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserUseCase(repository);
});

final userProvider = FutureProvider.autoDispose((ref) async {
  final useCase = ref.read(getUserUseCaseProvider);
  return useCase();
});
```

## What Another Agent Should Know

If another agent opens this folder later, they should:

- follow the build order above
- keep UI and API separate
- use the entity for app-level data
- use the model for API mapping
- use the use case for business logic
- use the provider as the Riverpod bridge

## Notes To Add Later

- endpoint URL
- user entity fields
- repository methods
- use case rules
- UI screen behavior
