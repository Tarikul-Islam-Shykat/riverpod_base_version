#!/bin/sh
#
# Usage:
#   chmod +x build_template.sh
#   sh build_template.sh
#
# This script only scaffolds empty feature folders and empty files.
# It does not add starter code.

set -eu

normalize_path_segment() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' _' '-' \
    | tr -cs 'a-z0-9-' '-' \
    | sed 's/^-//; s/-$//; s/--*/-/g'
}

normalize_feature_path() {
  input=$1
  normalized=""

  OLD_IFS=$IFS
  IFS='/'
  set -- $input
  IFS=$OLD_IFS

  for segment in "$@"; do
    [ -z "$segment" ] && continue
    segment=$(normalize_path_segment "$segment")
    [ -z "$segment" ] && continue
    if [ -z "$normalized" ]; then
      normalized=$segment
    else
      normalized=$normalized/$segment
    fi
  done

  printf '%s' "$normalized"
}

snake_case() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' -' '_' \
    | tr -cs 'a-z0-9_' '_' \
    | sed 's/^_//; s/_$//; s/__*/_/g'
}

create_empty_file() {
  file_path=$1
  mkdir -p "$(dirname "$file_path")"
  : > "$file_path"
}

create_splash_demo_screen() {
  file_path=$1
  mkdir -p "$(dirname "$file_path")"
  cat > "$file_path" <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
EOF
}

FEATURE_INPUT=${1:-}
BASE_INPUT=${2:-}
SKIP_INPUT=${3:-}

if [ -z "$FEATURE_INPUT" ]; then
  printf '%s' 'Feature name/path (example: splash or example/get-user): '
  read FEATURE_INPUT
fi

FEATURE_PATH=$(normalize_feature_path "$FEATURE_INPUT")
if [ -z "$FEATURE_PATH" ]; then
  printf '%s\n' 'Please provide a valid feature path.' >&2
  exit 1
fi

if [ -z "$BASE_INPUT" ]; then
  BASE_INPUT=$(basename "$FEATURE_PATH")
fi

BASE_NAME=$(snake_case "$BASE_INPUT")
if [ -z "$BASE_NAME" ]; then
  printf '%s\n' 'Could not determine a valid base name.' >&2
  exit 1
fi

if [ -z "$SKIP_INPUT" ]; then
  printf '%s' 'Skip any layers? (data,domain,presentation - comma separated, Enter for none): '
  read SKIP_INPUT
fi

SKIP_INPUT=$(printf '%s' "$SKIP_INPUT" | tr '[:upper:]' '[:lower:]')

should_skip_data=false
should_skip_domain=false
should_skip_presentation=false

case ",$SKIP_INPUT," in
  *",data,"*) should_skip_data=true ;;
esac

case ",$SKIP_INPUT," in
  *",domain,"*) should_skip_domain=true ;;
esac

case ",$SKIP_INPUT," in
  *",presentation,"*) should_skip_presentation=true ;;
esac

ROOT_DIR="lib/features/$FEATURE_PATH"

mkdir -p "$ROOT_DIR"

if [ "$should_skip_data" = false ]; then
  mkdir -p \
    "$ROOT_DIR/data/datasources/local" \
    "$ROOT_DIR/data/datasources/remote" \
    "$ROOT_DIR/data/models" \
    "$ROOT_DIR/data/repositories"
fi

if [ "$should_skip_domain" = false ]; then
  mkdir -p \
    "$ROOT_DIR/domain/entities" \
    "$ROOT_DIR/domain/repositories" \
    "$ROOT_DIR/domain/usecases"
fi

if [ "$should_skip_presentation" = false ]; then
  mkdir -p \
    "$ROOT_DIR/presentation/pages" \
    "$ROOT_DIR/presentation/providers" \
    "$ROOT_DIR/presentation/widgets"
fi

if [ "$should_skip_domain" = false ]; then
  create_empty_file "$ROOT_DIR/domain/entities/${BASE_NAME}_entity.dart"
  create_empty_file "$ROOT_DIR/domain/repositories/${BASE_NAME}_repository.dart"
  create_empty_file "$ROOT_DIR/domain/usecases/${BASE_NAME}_use_case.dart"
fi

if [ "$should_skip_data" = false ]; then
  create_empty_file "$ROOT_DIR/data/models/${BASE_NAME}_model.dart"
  create_empty_file "$ROOT_DIR/data/datasources/local/${BASE_NAME}_local_data_source.dart"
  create_empty_file "$ROOT_DIR/data/datasources/remote/${BASE_NAME}_remote_data_source.dart"
  create_empty_file "$ROOT_DIR/data/repositories/${BASE_NAME}_repository_impl.dart"
fi

if [ "$should_skip_presentation" = false ]; then
  if [ "$BASE_NAME" = "splash" ]; then
    create_splash_demo_screen "$ROOT_DIR/presentation/pages/${BASE_NAME}_screen.dart"
  else
    create_empty_file "$ROOT_DIR/presentation/pages/${BASE_NAME}_screen.dart"
  fi
  create_empty_file "$ROOT_DIR/presentation/providers/${BASE_NAME}_provider.dart"
  create_empty_file "$ROOT_DIR/presentation/widgets/.gitkeep"
fi

create_empty_file "$ROOT_DIR/README.md"

printf '%s\n' "✅ Scaffold created at: $ROOT_DIR"
