# Posts GET Feature Architecture V2

This is the version I should read when I feel confused about:

- what `posts_provider.dart` is doing
- why `autoDispose` exists
- why the providers are connected together
- what the use case is actually for
- how to build a feature from scratch in the right order

The feature lives here:
- [`lib/features/example/get-feature`](../example/get-feature)

The endpoint constant lives here:
- [`lib/core/constants/endpoinst.dart`](../../core/constants/endpoinst.dart)

---

## 1. The Short Answer

If I want to fetch posts, the layers work like this:

```text
UI
  -> Riverpod provider
  -> Use case
  -> Repository interface
  -> Repository implementation
  -> Remote data source
  -> Network service
  -> API
  -> JSON
  -> Model
  -> Entity
  -> UI
```

The UI does not call the API directly.
The provider does not parse JSON directly.
The use case does not know about HTTP.

Each layer has one job.

---

## 2. What `posts_provider.dart` Is For

File:
- [`posts_provider.dart`](../example/get-feature/presentation/providers/posts_provider.dart)

This file is not the API caller itself.
It is the **Riverpod bridge** between UI and feature logic.

It creates and connects the objects needed by the feature:

```dart
final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return PostsRemoteDataSource(networkService);
});

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  final remoteDataSource = ref.read(postsRemoteDataSourceProvider);
  return PostsRepositoryImpl(remoteDataSource);
});

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  final repository = ref.read(postsRepositoryProvider);
  return GetPostsUseCase(repository);
});

final postsProvider = FutureProvider.autoDispose<List<PostEntity>>((ref) async {
  final useCase = ref.watch(getPostsUseCaseProvider);
  final result = await useCase(limit: 20);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (posts) => posts,
  );
});
```

### Why this file exists

It keeps the UI simple.
The screen only needs to do:

```dart
final postsAsync = ref.watch(postsProvider);
```

It does not need to know:
- how to create the network service
- how to create the repository
- how to create the use case
- where the API lives

That is all hidden behind providers.

---

## 3. Why `autoDispose` Exists

This provider is:

```dart
FutureProvider.autoDispose<List<PostEntity>>
```

`autoDispose` means:
- when the screen stops using the provider
- Riverpod can dispose of it automatically

### Why this is useful

It helps with:
- memory cleanup
- unused state cleanup
- avoiding providers staying alive forever when the screen is gone

### In this feature

If I leave the posts screen and come back later:
- the provider can be recreated
- the data can be fetched again
- I get a fresh state

That is nice for a simple GET screen.

### When to use it

Use `autoDispose` when:
- the state is only needed while a screen is visible
- I want cleanup automatically
- I do not want stale UI state to remain alive forever

---

## 4. Why the Providers Are Connected

The providers are connected on purpose.
This is called dependency wiring.

### Example chain

```dart
postsProvider
  -> getPostsUseCaseProvider
  -> postsRepositoryProvider
  -> postsRemoteDataSourceProvider
  -> networkServiceProvider
```

Each provider asks for the thing below it.

### Why not create everything inside the screen?

Because that would make the screen too big and hard to test.

If the screen built everything manually:
- the UI would know too much
- changing the data source later would be messy
- testing would be harder

So Riverpod helps connect the pieces while keeping the screen clean.

---

## 5. What the Use Case Is Doing

File:
- [`get_posts_use_case.dart`](../example/get-feature/domain/usecases/get_posts_use_case.dart)

The use case is not just a pass-through anymore.
It now has real domain logic:

```dart
class GetPostsUseCase {
  GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<PostEntity>>> call({
    int limit = 20,
  }) async {
    final result = await _repository.getPosts();

    return result.map(
      (posts) {
        final normalizedPosts = posts
            .where(
              (post) => post.title.trim().isNotEmpty && post.body.trim().isNotEmpty,
            )
            .map(
              (post) => PostEntity(
                userId: post.userId,
                id: post.id,
                title: post.title.trim(),
                body: post.body.trim(),
              ),
            )
            .toList(growable: false)
          ..sort((left, right) => right.id.compareTo(left.id));

        if (limit <= 0) {
          return const <PostEntity>[];
        }

        return normalizedPosts.take(limit).toList(growable: false);
      },
    );
  }
}
```

### Why this matters

This shows the use case is the place for **business logic**.

It can:
- clean the data
- sort the data
- limit the data
- combine rules before the UI sees anything

### Why this is not in the UI

Because the UI should render data, not decide business rules.

---

## 6. What the Repository Is Doing

File:
- [`posts_repository.dart`](../example/get-feature/domain/repositories/posts_repository.dart)

This is the contract:

```dart
abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
}
```

It says:
- a posts source must know how to get posts
- it returns domain entities
- it returns either success or failure

### Why keep this in domain

Because the domain should not know whether the data comes from:
- API
- SQLite
- cache
- shared preferences

The repository interface just defines the feature promise.

---

## 7. What the Repository Implementation Is Doing

File:
- [`posts_repository_impl.dart`](../example/get-feature/data/repositories/posts_repository_impl.dart)

This is the concrete data bridge:

```dart
class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remoteDataSource);

  final PostsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    final result = await _remoteDataSource.getPosts();

    return result.map(
      (posts) => posts
          .map(
            (post) => PostEntity(
              userId: post.userId,
              id: post.id,
              title: post.title,
              body: post.body,
            ),
          )
          .toList(growable: false),
    );
  }
}
```

### Purpose

It connects:
- domain contract
- data source result

It converts data-layer objects into domain entities.

---

## 8. What the Data Source Is Doing

File:
- [`posts_remote_data_source.dart`](../example/get-feature/data/datasources/posts_remote_data_source.dart)

This is where the API request happens:

```dart
Future<Either<Failure, List<PostModel>>> getPosts() async {
  final result = await _networkService.get<List<dynamic>>(
    AppEndpoints.jsonPlaceholderPosts,
  );

  return result.map(
    (response) => response
        .whereType<Map>()
        .map((json) => PostModel.fromJson(Map<String, dynamic>.from(json)))
        .toList(growable: false),
  );
}
```

### Purpose

It does the raw fetching.
It knows:
- the endpoint
- the network service
- how to parse the response into models

It should not know about the UI.

---

## 9. What the Model Is Doing

File:
- [`post_model.dart`](../example/get-feature/data/models/post_model.dart)

The model converts raw JSON into a Dart object:

```dart
factory PostModel.fromJson(Map<String, dynamic> json) {
  return PostModel(
    userId: (json['userId'] as num).toInt(),
    id: (json['id'] as num).toInt(),
    title: json['title'] as String,
    body: json['body'] as String,
  );
}
```

### Why this exists

API response shape is not the same as app/domain shape.
The model is the API-friendly layer.

---

## 10. What the Entity Is Doing

File:
- [`post_entity.dart`](../example/get-feature/domain/entities/post_entity.dart)

The entity is the clean app object:

```dart
class PostEntity {
  const PostEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;
}
```

### Why entity and model are different

- `model` = data shape from API
- `entity` = clean shape used by app logic and UI

This separation keeps the app flexible.

---

## 11. How the Screen Uses the Provider

File:
- [`posts_page.dart`](../example/get-feature/presentation/pages/posts_page.dart)

The screen watches the provider:

```dart
final postsAsync = ref.watch(postsProvider);
```

Then it reacts to the state:

```dart
postsAsync.when(
  loading: () => ...
  error: (error, stackTrace) => ...
  data: (posts) => ...
)
```

### Why this is useful

The UI stays simple:
- if loading, show loader
- if error, show error
- if data, show posts

The UI does not care how the data was fetched.

---

## 12. Why `ref.read` and `ref.watch` Are Used Differently

### `ref.read`

Used to get a dependency once:

```dart
final networkService = ref.read(networkServiceProvider);
```

This is used in provider wiring because the provider is just creating objects.

### `ref.watch`

Used when the UI should react:

```dart
final postsAsync = ref.watch(postsProvider);
```

This causes rebuilds when the provider emits new values.

---

## 13. How to Build a Feature From Scratch

If I start a new feature tomorrow, I should build it in this order:

### Step 1: Create the feature folder

Example:

```text
lib/features/posts
```

Then create:

```text
presentation/
domain/
data/
```

### Step 2: Create the entity

Define what the thing is.

### Step 3: Create the repository contract

Define what operations the feature supports.

### Step 4: Create the use case

Put the business action there.

### Step 5: Create the model

Define how the API JSON maps to Dart.

### Step 6: Create the remote data source

Make the API call there.

### Step 7: Create the repository implementation

Connect the contract to the data source.

### Step 8: Create Riverpod providers

Wire everything together.

### Step 9: Create the screen

Read the provider and render the UI.

### Step 10: Connect routing

Add the route and navigate to it.

---

## 14. Why This Order Helps

This order keeps the feature stable because:
- the business meaning is defined first
- data access is separated
- UI becomes the last layer
- bugs are easier to trace

If something goes wrong, I can check the layer that owns the problem.

---

## 15. The Main Idea To Remember

### Riverpod
Riverpod is the dependency and state wiring tool.

### Domain
Domain is the business meaning and rules of the feature.

### Data
Data is the API/database/storage side.

### UI
UI only watches state and shows results.

---

## 16. One Last Summary

If I ask, “Why is `posts_provider.dart` needed?”

Answer:
- it connects the feature pieces
- it gives the UI a single provider to watch
- it keeps the screen clean
- it handles Riverpod state for loading/data/error

If I ask, “Why use a use case?”

Answer:
- to hold feature logic
- to keep business rules away from UI
- to make the feature easier to grow later

If I ask, “Why the domain layer?”

Answer:
- to define what the feature means
- to stay independent from API/UI/storage details

