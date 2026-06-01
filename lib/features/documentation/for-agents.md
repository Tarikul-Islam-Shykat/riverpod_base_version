# For Agents

This document explains the structure of this project and how to reuse it as a starter for a new Flutter project.

The goal is:

- keep reusable app code in one place
- let a new project install or sync the shared starter files
- replace the project name in `pubspec.yaml`
- avoid copying learning/demo-only files into the new project

## Starter Install Command

This repo includes a version helper that can be used from a fresh project root.

### From Project Root

```bash
git clone --depth 1 --filter=blob:none --sparse git@github.com:Tarikul-Islam-Shykat/features.git .tmp_vc && cd .tmp_vc && git sparse-checkout set version-helper/version_checker && cd .. && mkdir -p lib/core/helper && cp -r .tmp_vc/version-helper/version_checker lib/core/helper/ && sh lib/core/helper/version_checker/install.sh && rm -rf .tmp_vc
```

### From `lib/core/helper/`

```bash
git clone --depth 1 --filter=blob:none --sparse git@github.com:Tarikul-Islam-Shykat/features.git .tmp_vc && cd .tmp_vc && git sparse-checkout set version-helper/version_checker && cd .. && cp -r .tmp_vc/version-helper/version_checker ./ && sh version_checker/install.sh && rm -rf .tmp_vc
```

## What The Installer Should Do

The installer should be used in a brand-new Flutter project.

It should:

- overwrite or sync selected starter files
- keep reusable app code
- skip learning/demo-only files
- update `pubspec.yaml`
- replace `name: riverpod_base` with the new project name
- update package imports if they reference `package:riverpod_base/...`

## What Should Be Reused

These are the kinds of things that should be installed into the new project:

- `lib/core`
- reusable feature code
- `assets`
- dependency entries in `pubspec.yaml`
- shared services
- shared constants
- shared routing

## What Should Not Be Copied

These are example/learning files and should usually stay out of the new starter project:

- `lib/features/example`
- `lib/features/documentation`
- `lib/notes`
- any file that is only for learning, testing, or explaining this repo

## Folder Structure Rule

The app should keep the reusable code in two main places:

- `lib/core`
- `lib/features`

### `lib/core`

This is for shared app-wide code:

- constants
- services
- router
- environment

### `lib/features`

This is for feature-based app code.

Example structure:

```text
lib/features/<feature_name>/
  data/
  domain/
  presentation/
```

## Core Services Already Available

The installer should not recreate services that already exist.

### `core/services/network`

Use this for:

- API calls
- Dio setup
- interceptors
- network errors

### `core/services/local_storage_service`

Use this for:

- Drift database
- secure storage
- shared local persistence

### `core/services/log_service`

Use this for:

- logging
- log viewer
- app event tracking

### `core/services/text-service`

Use this for:

- reusable text widgets
- consistent typography helpers

### `core/services/spacing_service`

Use this for:

- spacing helpers
- layout consistency

### `core/services/image_picker`

Use this for:

- image picking
- image-related reusable behavior

### `core/services/image-view`

Use this for:

- image preview
- image viewer behavior

## Provider Wiring Rule

When another agent adds a provider, it should be defined based on the class constructor.

Example:

```dart
class UserRemoteDataSource {
  UserRemoteDataSource(this._networkService);
}
```

Then the provider should read `networkServiceProvider` and pass it in.

That means providers are used for wiring, not for business logic.

## Handoff Reminder

If another agent starts here, they should first check:

- `lib/features/documentation/README.md`
- `lib/features/documentation/provider_wiring_notes.md`
- `lib/features/documentation/riverpod_terms_interview_guide.md`
- `lib/features/documentation/user_save_sync_checklist.md`

Those files explain the structure, the Riverpod wiring, and the current feature flow.

