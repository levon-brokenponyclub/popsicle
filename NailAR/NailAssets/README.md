# NailAR - Sample Nail Assets

This directory contains placeholder assets for nail designs. In a production app, you would add high-quality PNG images for each nail style.

## Asset Guidelines

For best results, create nail design images with these specifications:

- **Format**: PNG with transparency
- **Resolution**: 512x768 pixels (portrait orientation)
- **Shape**: Oval/almond nail shape
- **Background**: Transparent
- **File naming**: `nail_[style-name].png`

## Sample Styles

The app currently uses programmatic rendering for these styles:

1. Classic French - Nude base with white tip
2. Glitter Gold - Gold with sparkle effect
3. Ruby Red - Deep red solid color
4. Baby Pink - Soft pink
5. Ocean Blue - Vibrant blue
6. Royal Purple - Rich purple
7. Sunset Gradient - Orange to pink gradient
8. Chrome Silver - Metallic silver
9. Matte Black - Flat black finish
10. Floral Design - Pink base with white floral dots
11. Geometric Pattern - Blue with white stripes
12. Holographic - Purple/cyan iridescent effect

## Adding Custom Assets

To add custom nail design images:

1. Create PNG images following the guidelines above
2. Add them to this NailAssets folder
3. Add them to the Xcode project (right-click NailAssets folder > Add Files to "NailAR")
4. Update `NailStyle.swift` to reference the image files
5. Modify `NailOverlayRenderer.swift` to use UIImage for texture rendering

Example code to load images:

```swift
if let image = UIImage(named: "nail_classic") {
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    // Apply to nail overlay
}
```
