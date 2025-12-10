//
//  ARCameraView.swift
//  NailAR
//
//  SwiftUI view that integrates camera feed with AR nail overlays
//

import SwiftUI
import AVFoundation
import UIKit

struct ARCameraView: UIViewControllerRepresentable {
    @ObservedObject var cameraManager: CameraManager
    @Binding var selectedStyle: NailStyle
    @Binding var capturePhoto: Bool
    
    func makeUIViewController(context: Context) -> ARCameraViewController {
        let controller = ARCameraViewController()
        controller.cameraManager = cameraManager
        controller.coordinator = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ARCameraViewController, context: Context) {
        uiViewController.selectedStyle = selectedStyle
        
        if capturePhoto {
            uiViewController.capturePhoto()
            DispatchQueue.main.async {
                capturePhoto = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        // Coordinator for handling callbacks if needed
    }
}

class ARCameraViewController: UIViewController {
    var cameraManager: CameraManager?
    var selectedStyle: NailStyle = .classic
    var coordinator: ARCameraView.Coordinator?
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var handTracker = HandTracker()
    private var overlayRenderer: NailOverlayRenderer?
    private var overlayView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupOverlayView()
        setupHandTracking()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager?.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager?.stopSession()
    }
    
    private func setupCamera() {
        guard let manager = cameraManager else { return }
        
        manager.setupCamera()
        
        let previewLayer = manager.getPreviewLayer()
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    
    private func setupOverlayView() {
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false
        view.addSubview(overlayView)
        self.overlayView = overlayView
        
        overlayRenderer = NailOverlayRenderer(view: overlayView)
    }
    
    private func setupHandTracking() {
        // Observe camera frames with orientation
        if let manager = cameraManager {
            manager.$currentFrame
                .compactMap { $0 }
                .combineLatest(manager.$currentFrameOrientation)
                .sink { [weak self] pixelBuffer, orientation in
                    self?.processFrame(pixelBuffer, orientation: orientation)
                }
                .store(in: &cancellables)
        }
        
        // Observe hand tracking results
        handTracker.$detectedHands
            .sink { [weak self] hands in
                self?.updateOverlays(for: hands)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func processFrame(_ pixelBuffer: CVPixelBuffer, orientation: CGImagePropertyOrientation) {
        // Process frame with hand tracker using correct orientation
        handTracker.processFrame(pixelBuffer, orientation: orientation)
    }
    
    private func updateOverlays(for hands: [HandLandmarks]) {
        guard let renderer = overlayRenderer,
              let overlayView = overlayView else { return }
        
        let viewSize = overlayView.bounds.size
        renderer.updateNailOverlays(hands: hands, style: selectedStyle, viewSize: viewSize)
    }
    
    func capturePhoto() {
        guard let overlayView = overlayView else { return }
        
        // Capture the view with overlays
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let capturedImage = image {
            PhotoCaptureManager.shared.savePhoto(capturedImage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        overlayView?.frame = view.bounds
    }
}

// Import Combine for publishers
import Combine
