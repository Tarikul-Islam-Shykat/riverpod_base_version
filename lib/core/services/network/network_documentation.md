# Modular Network Layer: Documentation & Usage

This documentation provides a comprehensive guide on how to use the modular network layer. All code setup (Interceptors, Error Handling, Dio Configuration) is abstracted away, allowing you to focus on making API calls.

## Core Features
- **Functional Error Handling**: Returns `Either<Failure, T>` for type-safe error management.
- **Explicit Authentication**: Control auth per-request using the `isAuth` flag.
- **Centralized Error Mapping**: Automatic conversion of HTTP status codes and Dio exceptions.
- **Multipart Support**: Specialized handling for file uploads with JSON data.

---

## 1. Basic HTTP Requests (Optimized)

By using our network extensions, you can call API methods directly on the `ref` object.

### GET Request
```dart
final result = await ref.get<Map<String, dynamic>>(
  '/products',
  queryParameters: {'category': 'electronics'},
);
```

### POST Request
```dart
final result = await ref.post<Map<String, dynamic>>(
  '/products',
  data: {"name": "Laptop", "price": 999},
  isAuth: true,
);
```

### PUT Request
```dart
final result = await ref.put<Map<String, dynamic>>(
  '/products/123',
  data: {"price": 899},
  isAuth: true,
);
```

### PATCH Request
```dart
final result = await ref.patch<Map<String, dynamic>>(
  '/users/profile',
  data: {"bio": "New bio"},
  isAuth: true,
);
```

### DELETE Request
```dart
final result = await ref.delete<Map<String, dynamic>>(
  '/products/123',
  isAuth: true,
);
```

---

## 2. Multipart Requests (Optimized)

```dart
final result = await ref.multipart<Map<String, dynamic>>(
  '/users/update-avatar',
  method: RequestMethod.post,
  data: {"userId": "user_001"},
  files: {"image": myFile},
  isAuth: true,
);
```

---

## 3. Error Handling Flow

The `Failure` object returned in the `Left` side of the `Either` can be used to show user-friendly messages.

```dart
result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      // Show "No Internet" UI
    } else if (failure is AuthFailure) {
      // Redirect to login
    } else {
      // Show generic error snackbar
      AppSnackbar.show(context: context, message: failure.message, isSuccess: false);
    }
  },
  (data) => print("Success!"),
);
```

## Summary of Keys & Parameters
- `url`: The endpoint path.
- `method`: Use `RequestMethod.get`, `.post`, `.put`, `.patch`, or `.delete`.
- `data`: For `request()`, this is the JSON body. For `multipartRequest()`, this is a map sent under the `data` field.
- `files`: A map of `String` keys to `File` objects for multipart uploads.
- `isAuth`: Set to `true` to include the `Authorization` header.
- `queryParameters`: A map for URL parameters (e.g., `?id=1&name=test`).
