#!/usr/bin/env bash
set -euo pipefail

APP_ID="com.silo7.popsicle"        # bundle ID
TEAM_ID="H8PXUJH7MU"               # Apple Developer Team ID
DEVICE_NAME="<IPHONE_OR_IPAD_NAME>" # e.g., "John's iPhone" or "Alice's iPad"
PROJECT_DIR="/Users/levongravett/Desktop/nail-app/NailAR"
DERIVED="${PROJECT_DIR}/build"

cd "$PROJECT_DIR"

# Build signed app for the connected device
xcodebuild \
  -scheme NailAR \
  -configuration Debug \
  -destination "platform=iOS,name=${DEVICE_NAME}" \
  -derivedDataPath "$DERIVED" \
  DEVELOPMENT_TEAM="$TEAM_ID"

# Resolve device UDID from name
UDID=$(xcrun devicectl list devices | awk -F'[()]' -v name="$DEVICE_NAME" '$0 ~ name {print $2; exit}')
if [[ -z "$UDID" ]]; then
  echo "Could not find device UDID for ${DEVICE_NAME}" >&2
  exit 1
fi

APP_PATH="$DERIVED/Build/Products/Debug-iphoneos/NailAR.app"

# Install and launch
xcrun devicectl device install app --device "$UDID" "$APP_PATH"
xcrun devicectl device process launch --device "$UDID" "$APP_ID"
