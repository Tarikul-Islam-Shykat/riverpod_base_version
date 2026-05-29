# Image Service & Multipart Upload Flow

This guide demonstrates the full flow of picking an image, compressing it to stay under 30KB, and uploading it to the server with accompanying JSON data using the modular network layer.

## The Flow

### 1. Initialize Services
First, obtain the instances of the services using Riverpod.

```dart
final imageService = ref.read(imageServiceProvider);
final networkService = ref.read(networkServiceProvider);
```

### 2. Pick and Compress Image
The `pickAndCompress` method combines picking and iterative compression into a single functional call.

```dart
final result = await imageService.pickAndCompress(
  source: ImageSource.gallery,
  targetSizeKb: 30, // Default is 30KB
);
```

### 3. Handle Result and Upload
Use the `fold` method from `fpdart` to handle failures and proceed with the upload on success.

```dart
result.fold(
  (failure) {
    // Handle picking or compression error
    AppSnackbar.show(context: context, message: failure.message, isSuccess: false);
  },
  (compressedFile) async {
    // Proceed to upload the compressed file
    final uploadResult = await networkService.multipartRequest<Map<String, dynamic>>(
      '/users/profile',
      method: RequestMethod.put,
      data: {
        "fullName": "John Doe",
        "phoneNumber": "1234567890",
      },
      files: {
        "image": compressedFile, // File is sent under 'image' key
      },
      isAuth: true,
    );

    uploadResult.fold(
      (networkFailure) => AppSnackbar.show(context: context, message: networkFailure.message, isSuccess: false),
      (data) => AppSnackbar.show(context: context, message: "Profile Updated!", isSuccess: true),
    );
  },
);
```

## Advanced: Manual Compression
If you already have a file and just want to compress it:

```dart
final compressResult = await imageService.compressImage(myFile, targetSizeKb: 30);
```

## Advanced: Multiple Images
Picking multiple images (compression would need to be called for each file):

```dart
final multiResult = await imageService.pickMultiImage(limit: 5);
```

## Summary of Keys
- **JSON Data**: Automatically encoded and sent under the `data` key.
- **Files**: Sent under the key you provide in the `files` map (e.g., `"image"`).
- **Auth**: Set `isAuth: true` to automatically include the Bearer token.
