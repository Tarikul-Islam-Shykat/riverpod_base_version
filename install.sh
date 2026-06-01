#!/usr/bin/env bash
#
# Run from the root of the target Flutter project:
#   chmod +x install.sh
#   ./install.sh
#
# The script will ask whether you want to:
#   - overwrite: replace matching starter files and update pubspec package name
#   - adjust: sync starter files without changing the existing pubspec package name

set -euo pipefail

SOURCE_REPO="${SOURCE_REPO:-git@github.com:Tarikul-Islam-Shykat/riverpod_base_version.git}"
PROJECT_NAME_INPUT="${1:-$(basename "$PWD")}"

normalize_project_name() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cs 'a-z0-9_' '_' \
    | sed 's/^_//; s/_$//; s/__*/_/g'
}

PROJECT_NAME="$(normalize_project_name "$PROJECT_NAME_INPUT")"
if [[ -z "$PROJECT_NAME" ]]; then
  echo "Could not determine a valid project name." >&2
  exit 1
fi

echo "Choose install mode:"
echo "  1) overwrite - replace matching files and update pubspec package name"
echo "  2) adjust     - sync starter files without changing pubspec package name"
echo "  3) clean     - remove starter folders/files from the current project"
read -r -p "Enter 1, 2 or 3: " INSTALL_MODE

case "$INSTALL_MODE" in
  1|overwrite|OVERWRITE)
    INSTALL_MODE="overwrite"
    ;;
  2|adjust|ADJUST)
    INSTALL_MODE="adjust"
    ;;
  3|clean|CLEAN)
    INSTALL_MODE="clean"
    ;;
  *)
    echo "Invalid choice. Please run the script again and choose 1, 2 or 3." >&2
    exit 1
    ;;
esac

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/rb_install.XXXXXX")"
TARGET_ROOT="$PWD"
CURRENT_PUBSPEC_FILE="$TMP_DIR/current_pubspec.yaml"

if [[ -f "$TARGET_ROOT/pubspec.yaml" ]]; then
  cp "$TARGET_ROOT/pubspec.yaml" "$CURRENT_PUBSPEC_FILE"
fi

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo "📦 Cloning starter repo..."
git clone --depth 1 --filter=blob:none --sparse "$SOURCE_REPO" "$TMP_DIR" >/dev/null

cd "$TMP_DIR"
git sparse-checkout set --no-cone lib/core lib/shared lib/main.dart assets pubspec.yaml README.md for-agents.md >/dev/null

echo "📁 Copying starter files into: $TARGET_ROOT"
rsync -a lib/ "$TARGET_ROOT/lib/"
rsync -a assets/ "$TARGET_ROOT/assets/"
cp pubspec.yaml "$TARGET_ROOT/pubspec.yaml"
cp README.md "$TARGET_ROOT/README.md"
cp for-agents.md "$TARGET_ROOT/for-agents.md"

if [[ "$INSTALL_MODE" == "overwrite" ]]; then
  echo "✏️ Updating package name to: $PROJECT_NAME"
  perl -0pi -e "s/^name:\\s*riverpod_base\\s*\$/name: $PROJECT_NAME/m" "$TARGET_ROOT/pubspec.yaml"

  echo "🔁 Updating package imports..."
  find "$TARGET_ROOT/lib" -type f \( -name '*.dart' -o -name '*.md' \) -print0 \
    | xargs -0 perl -0pi -e "s/package:riverpod_base/package:$PROJECT_NAME/g"
else
  if [[ "$INSTALL_MODE" == "adjust" ]]; then
    echo "🛠️ Adjust mode selected. Merging starter pubspec deps into your existing pubspec.yaml."
    if [[ -f "$CURRENT_PUBSPEC_FILE" ]]; then
      ruby - "$CURRENT_PUBSPEC_FILE" "$TMP_DIR/pubspec.yaml" "$TARGET_ROOT/pubspec.yaml" <<'RUBY'
current_path, starter_path, output_path = ARGV

current_lines = File.readlines(current_path, chomp: false)
starter_lines = File.readlines(starter_path, chomp: false)

def top_level_section?(line)
  line.match?(/^[A-Za-z0-9_]+:\s*$/)
end

def section_range(lines, section_name)
  start_index = lines.index { |line| line.match?(/^#{Regexp.escape(section_name)}:\s*$/) }
  return nil if start_index.nil?

  end_index = lines.length
  (start_index + 1...lines.length).each do |idx|
    if top_level_section?(lines[idx])
      end_index = idx
      break
    end
  end

  [start_index, end_index]
end

def package_blocks(lines, section_name)
  range = section_range(lines, section_name)
  return {} if range.nil?

  start_index, end_index = range
  blocks = {}
  idx = start_index + 1

  while idx < end_index
    line = lines[idx]

    if line.match?(/^  [A-Za-z0-9_.-]+:/)
      name = line.strip.split(':', 2).first
      block = [line]
      idx += 1

      while idx < end_index && lines[idx].match?(/^(?:    |\t)/)
        block << lines[idx]
        idx += 1
      end

      blocks[name] = block
      next
    end

    idx += 1
  end

  blocks
end

def merge_section!(current_lines, starter_lines, section_name)
  current_blocks = package_blocks(current_lines, section_name)
  starter_blocks = package_blocks(starter_lines, section_name)
  missing_blocks = starter_blocks.reject { |name, _| current_blocks.key?(name) }
  return current_lines if missing_blocks.empty?

  range = section_range(current_lines, section_name)

  if range.nil?
    current_lines << "\n" unless current_lines.last&.end_with?("\n")
    current_lines << "#{section_name}:\n"
    missing_blocks.each_value do |block|
      current_lines.concat(block)
    end
    return current_lines
  end

  start_index, end_index = range
  insertion = []
  missing_blocks.each_value do |block|
    insertion.concat(block)
  end

  current_lines.insert(end_index, *insertion)
  current_lines
end

merged_lines = current_lines.dup
merged_lines = merge_section!(merged_lines, starter_lines, 'dependencies')
merged_lines = merge_section!(merged_lines, starter_lines, 'dev_dependencies')

File.write(output_path, merged_lines.join)
RUBY
    fi
  else
    echo "🧹 Clean mode selected. Removing starter folders/files from the project."
    rm -rf "$TARGET_ROOT/lib/core"
    rm -rf "$TARGET_ROOT/lib/shared"
    rm -rf "$TARGET_ROOT/assets"
    rm -f "$TARGET_ROOT/for-agents.md"
    rm -f "$TARGET_ROOT/README.md"
    if [[ -f "$CURRENT_PUBSPEC_FILE" ]]; then
      cp "$CURRENT_PUBSPEC_FILE" "$TARGET_ROOT/pubspec.yaml"
    fi
  fi
fi

echo "✅ Starter sync completed."
