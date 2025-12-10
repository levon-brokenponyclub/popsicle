xcrun simctl install booted "$APP_PATH"
# Deployment (overview)

Pick the guide that matches your target:

- Real device (full AR, camera/hand tracking): see `deployment-device.md`.
- Simulator (UI only, no camera/hand tracking): see `deployment-sim.md`.

Shared prerequisites
- Xcode 15+ installed (or `xcode-select` pointing to it)
- Apple Developer account signed into Xcode (needed for device signing)
- Trusted device with Developer Mode enabled for physical deployments
- Bundle ID and signing set to your team for device builds

One-time bundle ID & team setup (for devices)
1) Open `popsicle/NailAR/NailAR.xcodeproj` → target **NailAR** → Signing & Capabilities.  
2) Set **Team** to your account; Xcode will set a bundle ID like `com.yourname.NailAR`.

After that, follow the appropriate guide above.
