# riverpod_base_version

This is a feature-based Flutter starter project built with Riverpod and clean architecture style layering.

## Starter Project Goal

This repo is meant to be reused as a base for new Flutter projects.

The reusable starter content should include:

- `lib/core`
- reusable shared feature code
- `assets`
- `pubspec.yaml` dependency entries

The following should stay out of the starter package:

- `lib/notes`
- `lib/features/example`
- `lib/features/documentation`

## Package Name Rule

When this repo is used as a starter for a new project, the package name in `pubspec.yaml` should be replaced.

Current name:

```yaml
name: riverpod_base
```

This should become the new project name when the starter is synced or copied.

## Project Structure

- `lib/core` for shared app-wide code
- `lib/features` for feature-based app code

## Core Services Already Available

Before creating a new shared service, check whether one already exists in:

- `lib/core/services/network`
- `lib/core/services/local_storage_service`
- `lib/core/services/log_service`
- `lib/core/services/text-service`
- `lib/core/services/spacing_service`
- `lib/core/services/image_picker`
- `lib/core/services/image-view`

## Documentation

Project handoff and learning notes live in:

- `lib/features/documentation/README.md`
- `for-agents.md`

## Getting Started

If you are using this repo as a fresh Flutter project, continue with your normal Flutter setup, then wire the reusable starter files into the new project as needed.

## Starter Copy Command

Run this from the root of a new Flutter project to copy the starter files into it:

```bash
git clone --depth 1 --filter=blob:none --sparse git@github.com:Tarikul-Islam-Shykat/riverpod_base_version.git .tmp_rb && cd .tmp_rb && git sparse-checkout set --no-cone lib/core lib/main.dart assets pubspec.yaml for-agents.md README.md && cd .. && cp -R .tmp_rb/lib ./ && cp -R .tmp_rb/assets ./ && cp .tmp_rb/pubspec.yaml ./ && cp .tmp_rb/for-agents.md ./ && cp .tmp_rb/README.md ./ && rm -rf .tmp_rb
```

What it copies:

- `lib/`
- `assets/`
- `pubspec.yaml`
- `for-agents.md`
- `README.md`

What it skips:

- `lib/notes`
- `lib/features/example`
- `lib/features/documentation`
