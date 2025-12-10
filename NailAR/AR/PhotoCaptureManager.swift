//
//  PhotoCaptureManager.swift
//  NailAR
//
//  Manages saving photos to the device photo library
//

import UIKit
import Photos

class PhotoCaptureManager {
    static let shared = PhotoCaptureManager()
    
    private init() {}
    
    func savePhoto(_ image: UIImage) {
        // Request photo library access if needed
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Photo library access denied")
                DispatchQueue.main.async {
                    self.showAccessDeniedAlert()
                }
                return
            }
            
            // Save the image
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.showSuccessAlert()
                    } else if let error = error {
                        print("Error saving photo: \(error)")
                        self.showErrorAlert()
                    }
                }
            }
        }
    }
    
    private func showSuccessAlert() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            let alert = UIAlertController(
                title: "Photo Saved!",
                message: "Your nail design photo has been saved to your photo library.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            rootViewController.present(alert, animated: true)
        }
    }
    
    private func showErrorAlert() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            let alert = UIAlertController(
                title: "Error",
                message: "Failed to save photo. Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            rootViewController.present(alert, animated: true)
        }
    }
    
    private func showAccessDeniedAlert() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            let alert = UIAlertController(
                title: "Access Denied",
                message: "Please enable photo library access in Settings to save photos.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            rootViewController.present(alert, animated: true)
        }
    }
}
