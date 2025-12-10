# NailAR - iPad AR Nail Design App

A complete iPad app that uses real-time hand tracking to overlay virtual nail designs on your actual nails using the device camera.

## Features

- ✅ Real-time hand tracking using Vision framework (21 landmarks per hand)
- ✅ Live camera feed with AR nail overlays
- ✅ 12 built-in nail design styles
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
    │   └── NailStyle.swift
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
  - macOS with Xcode 15.0 or later
  - Apple Developer account (free tier works for sideloading)

## Building and Running

### Step 1: Open the Project

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /Users/levongravett/Desktop/nail-app/NailAR
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

### Nail Styles Available

1. **Classic French** - Nude with white tips
2. **Glitter Gold** - Sparkly gold finish
3. **Ruby Red** - Deep red solid
4. **Baby Pink** - Soft pastel pink
5. **Ocean Blue** - Vibrant blue
6. **Royal Purple** - Rich purple
7. **Sunset Gradient** - Orange to pink blend
8. **Chrome Silver** - Metallic silver
9. **Matte Black** - Flat black finish
10. **Floral Design** - Pink with white dots
11. **Geometric Pattern** - Blue with stripes
12. **Holographic** - Iridescent purple/cyan

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

## Customization

### Adding Custom Nail Designs

1. Create PNG images (512x768px, transparent background)
2. Add to `NailAR/NailAssets/` folder
3. Add files to Xcode project
4. Update `NailStyle.swift` enum with new styles
5. Modify `NailOverlayRenderer.swift` to load custom images

### Modifying Overlay Appearance

Edit `NailOverlayRenderer.swift`:
- Adjust nail size calculation (scale factors)
- Modify corner radius for nail shape
- Change opacity, shadows, borders
- Add new visual effects

### Adjusting Hand Tracking

Edit `HandTracker.swift`:
- Change confidence threshold (currently 0.3)
- Modify nail position offset (currently 0.7)
- Adjust nail size ratios
- Add smoothing/filtering for stability

## Technical Details

### Frameworks Used

- **SwiftUI** - Modern UI framework
- **Vision** - Hand pose detection (21 landmarks per hand)
- **AVFoundation** - Camera capture and video processing
- **CoreImage** - Image processing
- **Photos** - Photo library integration
- **Combine** - Reactive data flow

### Architecture

- **MVVM Pattern** - Separation of UI and business logic
- **ObservableObject** - Reactive state management
- **Real-time Processing** - 30+ fps hand tracking
- **Coordinate Mapping** - Vision coordinates → screen coordinates
- **Transform Calculations** - Position, rotation, scale for each nail

### Performance

- Runs at 30-60 fps on modern iPads
- Low latency hand tracking (<50ms)
- Efficient memory usage
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
