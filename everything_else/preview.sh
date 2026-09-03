#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)
TEMP_ROOT=${TMPDIR:-/tmp}
mkdir -p "$TEMP_ROOT"
TEMP_ROOT=$(CDPATH= cd -- "$TEMP_ROOT" && pwd -P)
STAGE_DIR="$TEMP_ROOT/manelici-stage"
SUPPORT_DIR="$TEMP_ROOT/manelici-preview-support"

case "$STAGE_DIR/" in
  "$REPO_ROOT/"*)
    echo "Refusing to create the preview inside the repository: $STAGE_DIR" >&2
    exit 1
    ;;
esac

rm -rf "$STAGE_DIR" "$SUPPORT_DIR"
mkdir "$STAGE_DIR" "$SUPPORT_DIR"
cp -R "$SCRIPT_DIR/." "$STAGE_DIR/"
cp -R "$REPO_ROOT/files" "$REPO_ROOT/images" "$STAGE_DIR/"
cp "$REPO_ROOT/images/favicon.ico" "$STAGE_DIR/favicon.ico"
{
  printf -- '---\npermalink: /\ntitle: ""\nauthor_profile: false\n---\n'
  cat "$REPO_ROOT/main.md"
} > "$STAGE_DIR/index.md"

SCRATCH_GEMFILE="$SUPPORT_DIR/Gemfile"
RUBY_SHIM="$SUPPORT_DIR/ruby4_compat.rb"
printf '%s\n' \
  'eval_gemfile ENV.fetch("SOURCE_GEMFILE")' \
  "gem 'csv'" \
  "gem 'base64'" \
  "gem 'bigdecimal'" \
  "gem 'logger'" \
  "gem 'ostruct'" > "$SCRATCH_GEMFILE"
printf '%s\n' \
  'class Object' \
  '  def tainted? = false' \
  '  def taint = self' \
  '  def untaint = self' \
  'end' > "$RUBY_SHIM"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export BUNDLE_PATH="$HOME/.cache/bundle-manelici"
export BUNDLE_GEMFILE="$SCRATCH_GEMFILE"
export SOURCE_GEMFILE="$SCRIPT_DIR/Gemfile"
export RUBYOPT="-r$RUBY_SHIM -W0"

bundle install --local || bundle install
cd "$STAGE_DIR"
bundle exec jekyll serve --source "$STAGE_DIR" --destination "$STAGE_DIR/_site" -l
