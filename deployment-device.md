# Deployment – Real Device

Full AR (camera + hand tracking) requires running on a physical iPad or iPhone. Use this guide to deploy from Xcode for maximum compatibility or via CLI once signing is configured.

## Prerequisites
- Xcode 26.1+ installed (or `xcode-select` pointing to it)
- Install iOS platform support when Xcode prompts on first launch (select **iOS 26.1**)
- Apple Developer account signed into Xcode (free tier works for sideloading)
- Command Line Tools installed (`xcode-select --install`) if you plan to use CLI
- Device trusted via USB (Settings → General → VPN & Device Management → Developer App → Trust)
- Enable Developer Mode on device (iOS 16+)
- Bundle ID and signing set to your team

## One-time: set bundle ID & team
In Xcode (one-time step):
1) Open `popsicle/NailAR/NailAR.xcodeproj` → target **NailAR** → Signing & Capabilities.  
2) Set **Team** to **Popsicle Professional Nails (Pty) Ltd**.  
3) Set **Bundle Identifier** to `com.silo7.popsicle`.

## Xcode UI quick run (recommended first time)
1) Connect your device and trust it; enable Developer Mode if prompted.  
2) In Xcode, choose your device in the toolbar.  
3) Press **Run**. Xcode will build, sign, install, and launch the app.

## CLI: build, install, launch (device)
```bash
cd popsicle/NailAR
# List devices to get UDID
xcrun devicectl list devices

# Build for device (signs with your team)
xcodebuild \
  -scheme NailAR \
  -configuration Debug \
  -destination 'platform=iOS,name=<IPHONE_OR_IPAD_NAME>' \
  -derivedDataPath build \
  DEVELOPMENT_TEAM=<TEAM_ID>

# Install to device (Xcode 15+ devicectl)
xcrun devicectl device install app --device <DEVICE_UDID> build/Build/Products/Debug-iphoneos/NailAR.app

# Launch the app
xcrun devicectl device process launch --device <DEVICE_UDID> com.nailar.app
```

## Helper script (device)
Save as `scripts/deploy-device.sh` (make it executable `chmod +x scripts/deploy-device.sh`).
```bash
#!/usr/bin/env bash
set -euo pipefail
APP_ID="com.silo7.popsicle"      # bundle ID
TEAM_ID="<TEAM_ID>"               # your Apple Developer Team ID
DEVICE_NAME="<IPHONE_OR_IPAD_NAME>"  # e.g., "John's iPhone"
PROJECT_DIR="popsicle/NailAR"
DERIVED="${PROJECT_DIR}/build"

cd "$PROJECT_DIR"

# Build signed app for device
xcodebuild \
  -scheme NailAR \
  -configuration Debug \
  -destination "platform=iOS,name=${DEVICE_NAME}" \
  -derivedDataPath "$DERIVED" \
  DEVELOPMENT_TEAM="$TEAM_ID"

# Get UDID (first match by name)
UDID=$(xcrun devicectl list devices | awk -F'[()]' -v name="$DEVICE_NAME" '$0 ~ name {print $2; exit}')
if [[ -z "$UDID" ]]; then
  echo "Could not find device UDID for ${DEVICE_NAME}" >&2
  exit 1
fi

APP_PATH="$DERIVED/Build/Products/Debug-iphoneos/NailAR.app"

# Install
xcrun devicectl device install app --device "$UDID" "$APP_PATH"

# Launch
xcrun devicectl device process launch --device "$UDID" "$APP_ID"
```

## Troubleshooting
- Signing errors: ensure `DEVELOPMENT_TEAM` is set and you opened Xcode once to accept the developer license.
- Device not found: verify `xcrun devicectl list devices` shows your device, it is trusted, and Developer Mode is enabled.
- App will not launch: delete the derived data folder (`rm -rf build`), rebuild, reinstall.
- Camera/hand tracking unavailable on simulator; always use a real device to validate AR.
