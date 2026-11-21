#!/usr/bin/env bash
# 使用当前 Xcode SDK 构建完整工程，并导出可自行签名的 IPA。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
PROJECT_PATH="$PROJECT_DIR/PhotoCleaner.xcodeproj"
APP_DIR="$BUILD_DIR/PhotoCleaner.app"
mkdir -p "$BUILD_DIR"
WORK_DIR="$(mktemp -d "$BUILD_DIR/package.XXXXXX")"

# 退出时只清理本次创建的临时打包目录。
cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

# 从 Xcode 解析后的设置读取版本，避免与工程和资源声明脱节。
read_build_setting() {
  python3 - "$WORK_DIR/settings.json" "$1" <<'PY'
import json, sys
with open(sys.argv[1]) as source:
    targets = json.load(source)
settings = next(row['buildSettings'] for row in targets if row.get('target') == 'PhotoCleaner')
print(settings[sys.argv[2]])
PY
}

xcodebuild -project "$PROJECT_PATH" -scheme PhotoCleaner \
  -configuration Release -sdk iphoneos -showBuildSettings -json \
  > "$WORK_DIR/settings.json"
VERSION="$(read_build_setting MARKETING_VERSION)"
IPA_PATH="$BUILD_DIR/RollKeep-v${VERSION}.ipa"

if ! xcodebuild -project "$PROJECT_PATH" -scheme PhotoCleaner \
  -configuration Release -sdk iphoneos -destination 'generic/platform=iOS' \
  -derivedDataPath "$BUILD_DIR/DerivedData" \
  -archivePath "$WORK_DIR/PhotoCleaner.xcarchive" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  archive > "$BUILD_DIR/unsigned-build.log" 2>&1; then
  tail -n 50 "$BUILD_DIR/unsigned-build.log"
  exit 1
fi

mkdir -p "$WORK_DIR/Payload"
ditto "$WORK_DIR/PhotoCleaner.xcarchive/Products/Applications/PhotoCleaner.app" \
  "$WORK_DIR/Payload/PhotoCleaner.app"
ditto -c -k --keepParent "$WORK_DIR/Payload" "$IPA_PATH"
rm -rf "$APP_DIR"
ditto "$WORK_DIR/Payload/PhotoCleaner.app" "$APP_DIR"

printf '未签名应用：%s\n未签名 IPA：%s\n构建日志：%s\n' \
  "$APP_DIR" "$IPA_PATH" "$BUILD_DIR/unsigned-build.log"
