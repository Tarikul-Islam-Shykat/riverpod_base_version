# Example Features

This folder contains the example feature work used to learn Riverpod and feature-based development step by step.

## Main Goal

The main goal was to learn how a real feature is built in a clean way:

- start from the API shape
- define the entity
- separate domain and data
- wire the layers with Riverpod
- keep the UI simple
- learn how data flows from tap to API and back to the screen

This folder is also meant to be reusable as a handoff point for another agent later.

## What I Was Trying To Understand

I wanted to connect the dots between:

- where the API call happens
- who returns the data
- why the domain and data layers are separate
- how Riverpod providers depend on each other
- which provider the UI actually watches
- how to pass an id from a tapped card into a bottom sheet

## Current Example Features

### 1. Posts Feature

Path:
- [`get-post-feature`](get-post-feature)

What it teaches:
- simple `GET` feature flow
- API -> model -> entity -> use case -> provider -> UI
- list rendering from Riverpod

### 2. User Feature

Path:
- [`get-user-feature`](get-user-feature)

What it teaches:
- a richer API shape with nested objects
- separated data, domain, and presentation layers
- provider wiring
- tappable user cards
- bottom sheet comments flow

### 3. Home Shell

Path:
- [`home`](home)

What it teaches:
- simple app entry point
- routing into features

## Riverpod Flow I Learned

### Basic service provider

Example:

```dart
final imageServiceProvider = Provider((ref) => ImageService());
```

This creates a reusable service and makes it available through `ref`.

### Feature provider chain

Example:

```text
UI
-> usersProvider
-> getUsersUseCaseProvider
-> userRepositoryProvider
-> userRemoteDataSourceProvider
-> NetworkService
-> API
```

What I learned:
- the UI usually watches only the final provider
- the other providers support the chain underneath
- each provider depends on the one below it through `ref.read(...)`

## What The Layers Mean

### Presentation

This layer shows the UI.

It should:
- watch providers
- render loading/error/data states
- keep widget code simple

### Domain

This layer defines the meaning of the feature.

It holds:
- entities
- repository contracts
- use cases

This layer should not know about:
- Dio
- JSON
- UI widgets

### Data

This layer talks to the outside world.

It holds:
- models
- remote data sources
- repository implementations

This layer is where the actual API call happens.

## What I Learned About Providers

- `Provider` is used to create reusable objects like services, repositories, and use cases
- `FutureProvider` is used for async loading state
- `family` is used when the provider needs an argument like `postId`
- `autoDispose` is used when the provider should be cleaned up when the UI no longer uses it
- `ref.watch(...)` is used in the UI
- `ref.read(...)` is usually used inside provider wiring

## Comments Flow Lesson

The comments flow taught me that:

- a card tap can pass an id into a bottom sheet
- the bottom sheet can watch a parameterized provider
- `commentsProvider(postId)` is the connection point
- the bottom sheet does not need a full page
- the same feature can keep related data together while still staying clean

## Important Files

### Posts

- [`posts_page.dart`](get-post-feature/presentation/pages/posts_page.dart)
- [`posts_provider.dart`](get-post-feature/presentation/providers/posts_provider.dart)
- [`post_entity.dart`](get-post-feature/domain/entities/post_entity.dart)
- [`posts_remote_data_source.dart`](get-post-feature/data/datasources/posts_remote_data_source.dart)

### Users

- [`users_page.dart`](get-user-feature/presentation/pages/users_page.dart)
- [`user_provider.dart`](get-user-feature/presentation/providers/user_provider.dart)
- [`comment_provider.dart`](get-user-feature/presentation/providers/comment_provider.dart)
- [`user_entity.dart`](get-user-feature/domain/entities/user_entity.dart)
- [`comment_entity.dart`](get-user-feature/domain/entities/comment_entity.dart)
- [`user_remote_data_source.dart`](get-user-feature/data/datasources/user_remote_data_source.dart)
- [`comment_remote_data_source.dart`](get-user-feature/data/datasources/comment_remote_data_source.dart)
- [`comments_bottom_sheet.dart`](get-user-feature/presentation/widgets/comments_bottom_sheet.dart)
- [`user_card.dart`](get-user-feature/presentation/widgets/user_card.dart)

## Current Build Pattern

When starting a new feature, the order is:

1. inspect the API response
2. create the entity
3. create the repository contract
4. create the use case
5. create the model
6. create the remote data source
7. create the repository implementation
8. create the Riverpod providers
9. create the UI
10. connect routing or interaction

## What I Should Remember Next Time

- keep the feature small
- build one thing at a time
- use the UI only to render and trigger actions
- use the domain layer for feature meaning
- use the data layer for API calls and mapping
- use Riverpod to connect everything

## Handoff Note

If another agent starts from here, they should first read:

- [`get-user-feature/README.md`](get-user-feature/README.md)
- [`get-user-feature/connection_flow.md`](get-user-feature/connection_flow.md)

Those docs explain the detailed flow and the learning checklist for the most important feature.

