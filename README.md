# NailAR - iPad AR Nail Design App

## Overview

**Author**: Broken Pony Club / Levon Gravett  
**Website**: https://www.brokenpony.club  
**Version**: 1.0.2 (color-only, beta palette)

A complete iPad app that uses real-time hand tracking to overlay virtual nail designs on your actual nails using the device camera.

## What to Expect When Running

- Live camera feed with Apple Vision hand tracking (21 landmarks/hand) driving color-only nail overlays; no custom art is loaded.
- Overlays follow each fingertip; smoothing reduces jitter and nail sizes are clamped so they don’t shrink too small.
- Front/back camera supported; orientation is handled automatically for hand tracking.
- Simulator shows UI only (no camera/hand tracking). Use a real device for AR/vision.
- Permissions: first launch prompts for Camera and Photos; allow both for full functionality.

## Features

- ✅ Real-time hand tracking using Apple Vision (21 landmarks per hand)
- ✅ Live camera feed with color-only nail overlays (no custom art)
- ✅ 12 preset colors including 3 beta test shades
- ✅ Scrollable style picker UI
- ✅ Front/back camera switching
- ✅ Photo capture with overlays
- ✅ Export to Photos app
- ✅ iPad optimized interface
- ✅ Offline-capable (no internet required)
- ✅ Sideloadable via Xcode

## Project Structure

```
NailAR/
├── NailAR.xcodeproj/          # Xcode project file
└── NailAR/
    ├── NailARApp.swift        # App entry point
    ├── Info.plist             # App permissions & config
    ├── Assets.xcassets/       # App icons & assets
    │
    ├── Views/                 # SwiftUI Views
    │   ├── ContentView.swift
    │   ├── ARCameraView.swift
    │   └── NailStylePickerView.swift
    │
   ├── Models/                # Data models
   │   └── NailStyle.swift    # Color-only palette (no custom art)
    │
    ├── AR/                    # Camera & rendering
    │   ├── CameraManager.swift
    │   ├── NailOverlayRenderer.swift
    │   └── PhotoCaptureManager.swift
    │
    ├── Vision/                # Hand tracking
    │   └── HandTracker.swift
    │
    └── NailAssets/            # Nail design assets
        └── README.md
```

## Requirements

- **Device**: iPad with iOS 16.0 or later
- **Hardware**: Device with ARKit support and camera
- **Development**: 
   - macOS with Xcode 26.1 or later
   - Install iOS platform support in Xcode (at first launch screen, check **iOS 26.1**)
   - Apple Developer account (free tier works for sideloading)
   - Command Line Tools: `xcode-select --install` (or Xcode Settings → Locations → Command Line Tools)

## Building and Running

### Step 1: Open the Project

1. Open Terminal and navigate to the project directory:
   ```bash
   cd popsicle/NailAR
   ```

2. Open the Xcode project:
   ```bash
   open NailAR.xcodeproj
   ```

### Step 2: Configure Signing

1. In Xcode, select the **NailAR** project in the navigator
2. Select the **NailAR** target
3. Go to the **Signing & Capabilities** tab
4. Set your **Team** (sign in with your Apple ID if needed)
5. Xcode will automatically generate a Bundle Identifier like `com.yourname.NailAR`

### Step 3: Connect Your iPad

1. Connect your iPad to your Mac via USB cable
2. On your iPad, tap **Trust** when prompted
3. In Xcode, select your iPad from the device menu (top toolbar)

### Step 4: Build and Run

1. Click the **Play** button (▶️) in Xcode, or press `Cmd + R`
2. Xcode will build and install the app on your iPad
3. First time: On your iPad, go to **Settings → General → VPN & Device Management**
4. Tap your Apple ID under **Developer App**
5. Tap **Trust** to allow apps from your account

### Step 5: Launch the App

1. Open **NailAR** from your iPad home screen
2. Grant camera and photo library permissions when prompted
3. Point the camera at your hand
4. The app will automatically detect your fingers and overlay nail designs

## Using the App

### Basic Usage

1. **Hand Detection**: Hold your hand in front of the camera with fingers spread
2. **Style Selection**: Tap the palette icon (bottom-left) to open the style picker
3. **Choose Design**: Scroll and tap any nail style to apply it to all nails
4. **Switch Camera**: Tap the camera icon (bottom-right) to toggle front/back camera
5. **Capture Photo**: Tap the white circle button (center) to save a photo with overlays

### Best Practices

- Ensure good lighting for better hand tracking
- Hold your hand steadily for optimal overlay stability
- Keep fingers spread apart for better detection
- Try different angles and positions
- Use a plain background for clearer hand detection

### Nail Colors Available (color-only)

1. Natural Clear (subtle gloss)
2. Soft Nude
3. Blush Pink
4. Cherry Red
5. Coral
6. Sky Blue
7. Lilac
8. Emerald
9. Slate Matte
10. Beta: Sunrise
11. Beta: Lagoon
12. Beta: Amethyst

## Troubleshooting

### App Won't Install

- Ensure your iPad is running iOS 16.0 or later
- Check that your device is trusted in Xcode
- Verify signing configuration is correct
- Try cleaning build folder: `Cmd + Shift + K`, then rebuild

### Camera Not Working

- Check camera permissions in iPad Settings → NailAR
- Ensure no other app is using the camera
- Restart the app
- If using simulator, it won't have camera access (use real device)

### Hand Detection Issues

- Improve lighting conditions
- Spread fingers apart clearly
- Try different hand positions
- Ensure hand is in frame and not too close/far
- Clean camera lens

### Overlays Not Appearing

- Ensure hand is detected (fingers should be clearly visible)
- Try better lighting
- Adjust hand position
- Select a different nail style
- Restart the app

### Photo Save Failed

- Check photo library permissions in Settings → NailAR
- Ensure storage space is available
- Grant access when prompted

## What to Expect When Running

- Live camera feed with Apple Vision hand tracking (21 landmarks/hand) driving color-only nail overlays; no custom art is loaded.
- Overlays follow each fingertip; slight smoothing is applied to reduce jitter. Sizes are clamped so nails don’t shrink too small.
- Front/back camera supported; orientation is handled automatically for hand tracking.
- Simulator will show UI only (no camera/hand tracking). Use a real device for AR/vision.
- Permissions: first launch prompts for Camera and Photos; allow both for full functionality.

## Customization

### Hand Tracking Tuning (color-only build)

- Confidence threshold: 0.35 for tips/joints (Vision hand pose revision 3)
- Orientation: uses camera orientation (front/back aware) when processing frames
- Placement: nearest joint + tip; sizes clamped to avoid tiny nails
- Smoothing: applied to both detected landmarks and overlay transforms

## Technical Details

### Frameworks Used

- **SwiftUI** - Modern UI framework
- **Vision** - Hand pose detection (21 landmarks per hand), revision 3
- **AVFoundation** - Camera capture and video processing
- **CoreImage** - Image processing
- **Photos** - Photo library integration
- **Combine** - Reactive data flow

### Architecture

- **MVVM Pattern** - Separation of UI and business logic
- **ObservableObject** - Reactive state management
- **Real-time Processing** - 30+ fps hand tracking with smoothing
- **Coordinate Mapping** - Vision coordinates → screen coordinates with orientation handling
- **Transform Calculations** - Position, rotation, scale for each nail with size clamps

### Performance

- Runs at 30-60 fps on modern iPads
- Low latency hand tracking (<50ms)
- Efficient memory usage; smoothing to stabilize overlays
- Optimized for battery life

## Sideloading Notes

### Free Apple Developer Account

- Apps expire after 7 days and need re-signing
- Limited to 3 apps per device
- No TestFlight distribution

### Paid Developer Account ($99/year)

- Apps valid for 1 year
- Unlimited apps
- TestFlight distribution available
- App Store distribution possible

### Re-signing After Expiration

1. Open project in Xcode
2. Connect iPad
3. Click Run (▶️) again
4. App will be re-signed and installed

## License

Broken Pony Club

## Support

For issues or questions:
1. Check troubleshooting section above
2. Verify all requirements are met
3. Ensure latest iOS and Xcode versions
4. Review Xcode console for error messages

## Future Enhancements

Potential improvements:
- Save favorite nail styles
- Custom color picker
- More nail shapes (square, stiletto, etc.)
- Hand size calibration
- Multi-color designs per nail
- AR anchoring improvements
- Video recording with overlays
- Social sharing features

## Git Notes (do not forget)

Use the repo at `https://github.com/levon-brokenponyclub/popsicle.git`.

Common commands:

- Set remote (already set):
   ```bash
   git remote set-url origin https://github.com/levon-brokenponyclub/popsicle.git
   ```
- Check status:
   ```bash
   git status -sb
   ```
- Commit and push:
   ```bash
   git add .
   git commit -m "<message>"
   git push origin main
   ```
- Fresh clone (new folder):
   ```bash
   git clone https://github.com/levon-brokenponyclub/popsicle.git popsicle
   cd popsicle
   ```
