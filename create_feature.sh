#!/usr/bin/env bash
#
# Run from the root of this project:
#   chmod +x create_feature.sh
#   ./create_feature.sh splash
#
# You can also provide an optional second argument for the file base name:
#   ./create_feature.sh "get-user-feature" user
#
# This script creates a Riverpod + clean architecture feature skeleton under:
#   lib/features/<feature_path>/

set -euo pipefail

normalize_path_segment() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' _' '-' \
    | tr -cs 'a-z0-9-' '-' \
    | sed 's/^-//; s/-$//; s/--*/-/g'
}

normalize_feature_path() {
  local input="$1"
  local -a parts
  local segment
  local normalized=""

  IFS='/' read -ra parts <<< "$input"
  for segment in "${parts[@]}"; do
    [[ -z "$segment" ]] && continue
    segment="$(normalize_path_segment "$segment")"
    [[ -z "$segment" ]] && continue
    normalized+="${normalized:+/}$segment"
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

pascal_case() {
  printf '%s' "$1" | awk -F'[_-]' '{
    for (i = 1; i <= NF; i++) {
      if (length($i) == 0) continue
      printf "%s%s", toupper(substr($i, 1, 1)), tolower(substr($i, 2))
    }
  }'
}

FEATURE_INPUT="${1:-}"
BASE_INPUT="${2:-}"

if [[ -z "$FEATURE_INPUT" ]]; then
  read -r -p "Feature name/path (example: splash_screen or example/get-user-feature): " FEATURE_INPUT
fi

FEATURE_PATH="$(normalize_feature_path "$FEATURE_INPUT")"
if [[ -z "$FEATURE_PATH" ]]; then
  echo "Please provide a valid feature path." >&2
  exit 1
fi

if [[ -z "$BASE_INPUT" ]]; then
  BASE_INPUT="$(basename "$FEATURE_PATH")"
fi

BASE_NAME="$(snake_case "$BASE_INPUT")"
BASE_PASCAL="$(pascal_case "$BASE_NAME")"

if [[ -z "$BASE_NAME" || -z "$BASE_PASCAL" ]]; then
  echo "Could not determine a valid base name." >&2
  exit 1
fi

ROOT_DIR="lib/features/$FEATURE_PATH"

if [[ -z "${2:-}" ]]; then
  echo "Feature folder: $ROOT_DIR"
  echo "File base name: $BASE_NAME"
fi

mkdir -p \
  "$ROOT_DIR/data/datasources/local" \
  "$ROOT_DIR/data/datasources/remote" \
  "$ROOT_DIR/data/models" \
  "$ROOT_DIR/data/repositories" \
  "$ROOT_DIR/domain/entities" \
  "$ROOT_DIR/domain/repositories" \
  "$ROOT_DIR/domain/usecases" \
  "$ROOT_DIR/presentation/pages" \
  "$ROOT_DIR/presentation/providers" \
  "$ROOT_DIR/presentation/widgets"

cat > "$ROOT_DIR/domain/entities/${BASE_NAME}_entity.dart" <<EOF
class ${BASE_PASCAL}Entity {
  const ${BASE_PASCAL}Entity();
}
EOF

cat > "$ROOT_DIR/domain/repositories/${BASE_NAME}_repository.dart" <<EOF
import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../entities/${BASE_NAME}_entity.dart';

abstract class ${BASE_PASCAL}Repository {
  Future<Either<Failure, ${BASE_PASCAL}Entity>> get${BASE_PASCAL}();
}
EOF

cat > "$ROOT_DIR/domain/usecases/get_${BASE_NAME}_use_case.dart" <<EOF
import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../entities/${BASE_NAME}_entity.dart';
import '../repositories/${BASE_NAME}_repository.dart';

class Get${BASE_PASCAL}UseCase {
  Get${BASE_PASCAL}UseCase(this._repository);

  final ${BASE_PASCAL}Repository _repository;

  Future<Either<Failure, ${BASE_PASCAL}Entity>> call() {
    return _repository.get${BASE_PASCAL}();
  }
}
EOF

cat > "$ROOT_DIR/data/models/${BASE_NAME}_model.dart" <<EOF
import '../../domain/entities/${BASE_NAME}_entity.dart';

class ${BASE_PASCAL}Model {
  const ${BASE_PASCAL}Model();

  ${BASE_PASCAL}Entity toEntity() {
    return const ${BASE_PASCAL}Entity();
  }
}
EOF

cat > "$ROOT_DIR/data/datasources/local/${BASE_NAME}_local_data_source.dart" <<EOF
class ${BASE_PASCAL}LocalDataSource {
  const ${BASE_PASCAL}LocalDataSource();
}
EOF

cat > "$ROOT_DIR/data/datasources/remote/${BASE_NAME}_remote_data_source.dart" <<EOF
class ${BASE_PASCAL}RemoteDataSource {
  const ${BASE_PASCAL}RemoteDataSource();
}
EOF

cat > "$ROOT_DIR/data/repositories/${BASE_NAME}_repository_impl.dart" <<EOF
import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../../domain/entities/${BASE_NAME}_entity.dart';
import '../../domain/repositories/${BASE_NAME}_repository.dart';

class ${BASE_PASCAL}RepositoryImpl implements ${BASE_PASCAL}Repository {
  const ${BASE_PASCAL}RepositoryImpl();

  @override
  Future<Either<Failure, ${BASE_PASCAL}Entity>> get${BASE_PASCAL}() {
    throw UnimplementedError('Implement the ${BASE_NAME} repository.');
  }
}
EOF

cat > "$ROOT_DIR/presentation/providers/${BASE_NAME}_provider.dart" <<EOF
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ${BASE_NAME}Provider = Provider((ref) {
  throw UnimplementedError('Wire the ${BASE_NAME} feature providers here.');
});
EOF

cat > "$ROOT_DIR/presentation/pages/${BASE_NAME}_page.dart" <<EOF
import 'package:flutter/material.dart';

class ${BASE_PASCAL}Page extends StatelessWidget {
  const ${BASE_PASCAL}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${BASE_PASCAL} Page'),
      ),
    );
  }
}
EOF

cat > "$ROOT_DIR/presentation/widgets/.gitkeep" <<EOF

EOF

cat > "$ROOT_DIR/README.md" <<EOF
# $FEATURE_PATH

This feature was scaffolded with \`create_feature.sh\`.

## Next Steps

- fill the entity
- fill the repository contract
- connect the data sources
- wire the provider
- build the UI
EOF

echo "✅ Created feature scaffold at: $ROOT_DIR"
