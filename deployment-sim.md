# Deployment – Simulator

Use this flow to quickly exercise the UI on an iOS Simulator. Camera/hand tracking is not available in the simulator; use a real device for AR.

## Prerequisites
- Xcode 15+ installed (or `xcode-select` pointing to it)
- Simulator runtime installed (e.g., iPad 10th gen)
- No signing changes needed for simulator builds

## CLI: build, install, launch (simulator)
```bash
cd popsicle/NailAR
xcrun simctl boot "iPad (10th generation)" || true
xcodebuild -scheme NailAR -destination 'platform=iOS Simulator,name=iPad (10th generation)' -configuration Debug -derivedDataPath build
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/NailAR.app
xcrun simctl launch booted com.nailar.app
```

## Helper script (simulator)
Save as `scripts/deploy-sim.sh` (make it executable `chmod +x scripts/deploy-sim.sh`).
```bash
#!/usr/bin/env bash
set -euo pipefail
SIM_NAME="iPad (10th generation)"
APP_ID="com.nailar.app"
PROJECT_DIR="popsicle/NailAR"
DERIVED="${PROJECT_DIR}/build"

cd "$PROJECT_DIR"

xcrun simctl boot "$SIM_NAME" || true
xcodebuild -scheme NailAR -destination "platform=iOS Simulator,name=${SIM_NAME}" -configuration Debug -derivedDataPath "$DERIVED"
APP_PATH="$DERIVED/Build/Products/Debug-iphonesimulator/NailAR.app"
xcrun simctl install booted "$APP_PATH"
xcrun simctl launch booted "$APP_ID"
```

## Notes
- Simulator camera passthrough is not supported; expect static UI only.
- If launch fails, remove derived data (`rm -rf build`), rebuild, reinstall.
- To preview on an iPhone simulator, change `SIM_NAME` and destination accordingly.
