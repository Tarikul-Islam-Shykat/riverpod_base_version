# My Project Examples

## Counter Example

File:
- `lib/main.dart`

What it teaches:
- `NotifierProvider` holds state
- `ref.watch(counterProvider)` rebuilds the UI when the counter changes
- `ref.read(counterProvider.notifier).increment()` updates the state

## Image Service Example

File:
- `lib/core/services/image_picker/image_service.dart`

What it teaches:
- a service can be exposed with `Provider`
- the service can be reused in many places
- I do not need to manually create the service in every widget

## Network Service Example

File:
- `lib/core/services/network/service/network_service.dart`

What it teaches:
- providers can depend on other providers
- `networkServiceProvider` watches `dioProvider`
- Riverpod helps build dependencies in a clean chain

## Secure Storage Example

File:
- `lib/core/services/local_storage_service/secure/secure_storage.dart`

What it teaches:
- a storage service can also be wrapped in a provider
- this keeps access consistent across the app

## Logger Example

File:
- `lib/core/services/log_service/log_service.dart`

What it teaches:
- a provider can expose a reusable service
- another provider can expose async stream data from that service
- Riverpod can be used for services, not only UI state
