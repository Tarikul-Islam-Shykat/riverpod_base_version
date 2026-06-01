# For Agents

This is the handoff document for the project structure that is being followed in this codebase.

The goal is simple:

- understand the folder structure quickly
- know what already exists in `core`
- know where to add new features
- know when to reuse an existing service instead of creating a new one
- keep the code clean and easy for another agent to continue

## What This Project Is Doing

This project is following a **feature-based structure** with **clean architecture style layering** inside each feature.

That means:

- feature code is grouped by feature
- each feature has its own `domain`, `data`, and `presentation` folders
- shared app-level tools live in `core`
- Riverpod is used to connect everything

## Installer Note

See the root [`README.md`](README.md) for the starter project rules and package name replacement note.

## Top-Level Structure

The important top-level folders are:

- `lib/core`
- `lib/features`

### `lib/core`

This folder is for shared app-wide code.

It contains things like:

- constants
- routing
- environment config
- shared services

### `lib/features`

This folder is for feature-by-feature app code.

It contains:

- example features used for learning
- documentation for the project flow
- future feature modules

## Core Folder Rules

`core` is for things that are not tied to one feature only.

If something can be reused in many places, it usually belongs here.

## What Already Exists In `core`

### `core/constants`

This folder stores app-wide constants such as:

- API endpoints
- colors
- icon paths
- image paths
- text values
- animation paths

Use this folder when you need a value that should not be repeated across features.

### `core/env`

This folder stores environment-related config.

Use it when you need:

- build-time config
- environment variables
- generated env files

### `core/router`

This folder stores app routing.

Use it when you need:

- navigation paths
- route definitions
- route-level page setup

### `core/services`

This folder stores shared services that the app already knows how to use.

The rule is:

> before creating a new service, check whether one already exists here.

## Existing Services In `core/services`

### `image-view`

This is already available for image viewing / preview behavior.

Use it when:

- you need to show or preview images
- you want an existing image viewer instead of creating one from scratch

### `image_picker`

This is already available for image picking related behavior.

Use it when:

- you need to pick an image
- you want to reuse the existing image service

### `local_storage_service`

This is where local storage support lives.

It currently includes:

- `shared/app_db.dart`
- `secure/secure_storage.dart`

Use this service when you need:

- local database storage
- shared local persistence
- secure storage

Important:

- do not recreate the database service inside a feature
- reuse the shared app database provider instead

### `log_service`

This service handles app logging.

Use it when:

- you want to log debug or app events
- you want to inspect logs in the log viewer

Important:

- reuse this service rather than making a second logger

### `network`

This folder contains networking setup and helpers.

Use it when:

- you need API calls
- you need Dio configuration
- you need error handling for network requests
- you need interceptors

This is the shared network layer for the app.

### `spacing_service`

This service is for spacing helpers and layout consistency.

Use it when:

- you want app-wide spacing constants or helpers

### `text-service`

This service is for text widgets / text helpers used across the app.

Use it when:

- you want reusable text styling helpers
- you want consistent typography widgets

## Feature Folder Rules

Each feature should be built in its own folder.

Example:

```text
lib/features/example/get-user-feature
```

Inside a feature, keep the structure like this:

```text
feature/
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
    widgets/
```

## What Each Feature Folder Means

### `domain`

This is the feature meaning layer.

It contains:

- entities
- repository contracts
- use cases

This layer should not know about:

- Flutter UI
- API details
- JSON parsing
- local DB implementation details

### `data`

This is the feature implementation layer.

It contains:

- models
- remote data sources
- local data sources
- repository implementations

This is where API and database work happens.

### `presentation`

This is the UI layer.

It contains:

- pages
- widgets
- Riverpod providers

This layer should:

- watch providers
- show loading/error/data states
- keep the UI simple

## Provider Rule

Riverpod providers are used to connect the layers.

General pattern:

```text
UI
-> provider
-> use case
-> repository
-> data source
-> service
```

### How To Decide What A Provider Should Read

Look at the constructor of the class you are creating.

Example:

```dart
class UserRemoteDataSource {
  UserRemoteDataSource(this._networkService);
}
```

This means the provider should read:

- `networkServiceProvider`

Example:

```dart
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserRemoteDataSource(networkService);
});
```

## Reuse Existing Services Rule

Before creating any new service, check:

1. `lib/core/services`
2. `lib/core/constants`
3. `lib/core/router`
4. existing feature folders

If something already exists there, reuse it.

Do not duplicate:

- network service
- database service
- logger
- text helpers
- spacing helpers
- image helpers

## When To Create A New Service

Create a new service only when:

- nothing existing already does the job
- the behavior is shared across the app
- it is not tied to one tiny widget only

## Example Feature Flow

For the user feature, the current flow is roughly:

```text
UsersPage
-> usersProvider
-> getUsersUseCaseProvider
-> userRepositoryProvider
-> userRemoteDataSourceProvider
-> networkServiceProvider
-> API
```

For local save flow:

```text
UsersPage
-> localUserUseCaseProvider
-> userRepositoryProvider
-> userLocalDataSourceProvider
-> appDbProvider
-> Drift database
```

## What Another Agent Should Do First

If another agent starts here, they should first read:

- `lib/features/example/README.md`
- `lib/features/example/get-user-feature/README.md`
- `lib/features/documentation/provider_wiring_notes.md`
- `lib/features/documentation/riverpod_terms_interview_guide.md`

Then they should check:

- what service already exists in `core/services`
- whether the feature already has an entity
- whether the repository contract already exists
- whether a provider already exists before creating a new one

## Good Habit Checklist

- reuse existing core services
- keep feature code inside the feature folder
- keep domain pure
- keep data implementation details in data
- keep provider wiring separate from business logic
- keep UI focused on rendering and user actions

## Final Rule

If you are unsure where something belongs, ask:

- is this shared across the app? -> `core`
- is this only for one feature? -> `features/<feature>`
- is this business meaning? -> `domain`
- is this API or DB work? -> `data`
- is this UI or provider wiring? -> `presentation`
