#!/usr/bin/env bash
set -euo pipefail

SIM_NAME="iPad (10th generation)"   # change to another simulator if desired
APP_ID="com.silo7.popsicle"
PROJECT_DIR="/Users/levongravett/Desktop/nail-app/NailAR"
DERIVED="${PROJECT_DIR}/build"

cd "$PROJECT_DIR"

# Boot simulator and build
xcrun simctl boot "$SIM_NAME" || true
xcodebuild -scheme NailAR -destination "platform=iOS Simulator,name=${SIM_NAME}" -configuration Debug -derivedDataPath "$DERIVED"

APP_PATH="$DERIVED/Build/Products/Debug-iphonesimulator/NailAR.app"

# Install and launch on the simulator
xcrun simctl install booted "$APP_PATH"
xcrun simctl launch booted "$APP_ID"
