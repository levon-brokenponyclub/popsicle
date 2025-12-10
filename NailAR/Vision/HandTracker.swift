//
//  HandTracker.swift
//  NailAR
//
//  Vision-based hand tracking for detecting finger landmarks
//

import Foundation
import Vision
import AVFoundation
import CoreImage
import UIKit

class HandTracker: ObservableObject {
    @Published var detectedHands: [HandLandmarks] = []
    
    private var handPoseRequest: VNDetectHumanHandPoseRequest?
    
    init() {
        setupVision()
    }
    
    private func setupVision() {
        handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest?.maximumHandCount = 2 // Track both hands
    }
    
    // Process a frame to detect hands
    func processFrame(_ pixelBuffer: CVPixelBuffer, orientation: CGImagePropertyOrientation = .up) {
        guard let request = handPoseRequest else { return }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:])
        
        do {
            try handler.perform([request])
            
            if let observations = request.results, !observations.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.processObservations(observations)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.detectedHands = []
                }
            }
        } catch {
            print("Hand tracking error: \(error)")
        }
    }
    
    private func processObservations(_ observations: [VNHumanHandPoseObservation]) {
        var hands: [HandLandmarks] = []
        
        for observation in observations {
            if let handLandmarks = extractLandmarks(from: observation) {
                hands.append(handLandmarks)
            }
        }
        
        self.detectedHands = hands
    }
    
    private func extractLandmarks(from observation: VNHumanHandPoseObservation) -> HandLandmarks? {
        guard let allPoints = try? observation.recognizedPoints(.all) else {
            return nil
        }
        
        // Extract fingertip points for all five fingers
        var fingerTips: [FingerType: CGPoint] = [:]
        var fingerJoints: [FingerType: [CGPoint]] = [:]
        
        // Thumb
        if let thumbTip = allPoints[.thumbTip], thumbTip.confidence > 0.3 {
            fingerTips[.thumb] = CGPoint(x: thumbTip.location.x, y: thumbTip.location.y)
            
            var thumbPoints: [CGPoint] = []
            if let thumbIP = allPoints[.thumbIP], thumbIP.confidence > 0.3 {
                thumbPoints.append(CGPoint(x: thumbIP.location.x, y: thumbIP.location.y))
            }
            if let thumbMP = allPoints[.thumbMP], thumbMP.confidence > 0.3 {
                thumbPoints.append(CGPoint(x: thumbMP.location.x, y: thumbMP.location.y))
            }
            if let thumbCMC = allPoints[.thumbCMC], thumbCMC.confidence > 0.3 {
                thumbPoints.append(CGPoint(x: thumbCMC.location.x, y: thumbCMC.location.y))
            }
            fingerJoints[.thumb] = thumbPoints
        }
        
        // Index finger
        if let indexTip = allPoints[.indexTip], indexTip.confidence > 0.3 {
            fingerTips[.index] = CGPoint(x: indexTip.location.x, y: indexTip.location.y)
            
            var indexPoints: [CGPoint] = []
            if let indexDIP = allPoints[.indexDIP], indexDIP.confidence > 0.3 {
                indexPoints.append(CGPoint(x: indexDIP.location.x, y: indexDIP.location.y))
            }
            if let indexPIP = allPoints[.indexPIP], indexPIP.confidence > 0.3 {
                indexPoints.append(CGPoint(x: indexPIP.location.x, y: indexPIP.location.y))
            }
            if let indexMCP = allPoints[.indexMCP], indexMCP.confidence > 0.3 {
                indexPoints.append(CGPoint(x: indexMCP.location.x, y: indexMCP.location.y))
            }
            fingerJoints[.index] = indexPoints
        }
        
        // Middle finger
        if let middleTip = allPoints[.middleTip], middleTip.confidence > 0.3 {
            fingerTips[.middle] = CGPoint(x: middleTip.location.x, y: middleTip.location.y)
            
            var middlePoints: [CGPoint] = []
            if let middleDIP = allPoints[.middleDIP], middleDIP.confidence > 0.3 {
                middlePoints.append(CGPoint(x: middleDIP.location.x, y: middleDIP.location.y))
            }
            if let middlePIP = allPoints[.middlePIP], middlePIP.confidence > 0.3 {
                middlePoints.append(CGPoint(x: middlePIP.location.x, y: middlePIP.location.y))
            }
            if let middleMCP = allPoints[.middleMCP], middleMCP.confidence > 0.3 {
                middlePoints.append(CGPoint(x: middleMCP.location.x, y: middleMCP.location.y))
            }
            fingerJoints[.middle] = middlePoints
        }
        
        // Ring finger
        if let ringTip = allPoints[.ringTip], ringTip.confidence > 0.3 {
            fingerTips[.ring] = CGPoint(x: ringTip.location.x, y: ringTip.location.y)
            
            var ringPoints: [CGPoint] = []
            if let ringDIP = allPoints[.ringDIP], ringDIP.confidence > 0.3 {
                ringPoints.append(CGPoint(x: ringDIP.location.x, y: ringDIP.location.y))
            }
            if let ringPIP = allPoints[.ringPIP], ringPIP.confidence > 0.3 {
                ringPoints.append(CGPoint(x: ringPIP.location.x, y: ringPIP.location.y))
            }
            if let ringMCP = allPoints[.ringMCP], ringMCP.confidence > 0.3 {
                ringPoints.append(CGPoint(x: ringMCP.location.x, y: ringMCP.location.y))
            }
            fingerJoints[.ring] = ringPoints
        }
        
        // Little finger
        if let littleTip = allPoints[.littleTip], littleTip.confidence > 0.3 {
            fingerTips[.little] = CGPoint(x: littleTip.location.x, y: littleTip.location.y)
            
            var littlePoints: [CGPoint] = []
            if let littleDIP = allPoints[.littleDIP], littleDIP.confidence > 0.3 {
                littlePoints.append(CGPoint(x: littleDIP.location.x, y: littleDIP.location.y))
            }
            if let littlePIP = allPoints[.littlePIP], littlePIP.confidence > 0.3 {
                littlePoints.append(CGPoint(x: littlePIP.location.x, y: littlePIP.location.y))
            }
            if let littleMCP = allPoints[.littleMCP], littleMCP.confidence > 0.3 {
                littlePoints.append(CGPoint(x: littleMCP.location.x, y: littleMCP.location.y))
            }
            fingerJoints[.little] = littlePoints
        }
        
        // Get wrist position
        var wrist: CGPoint?
        if let wristPoint = allPoints[.wrist], wristPoint.confidence > 0.3 {
            wrist = CGPoint(x: wristPoint.location.x, y: wristPoint.location.y)
        }
        
        // Determine handedness (left or right)
        let chirality: HandChirality = observation.chirality == .right ? .right : .left
        
        return HandLandmarks(
            fingerTips: fingerTips,
            fingerJoints: fingerJoints,
            wrist: wrist,
            chirality: chirality
        )
    }
}

// MARK: - Supporting Types

enum FingerType: String, CaseIterable {
    case thumb
    case index
    case middle
    case ring
    case little
}

enum HandChirality {
    case left
    case right
}

struct HandLandmarks {
    let fingerTips: [FingerType: CGPoint]
    let fingerJoints: [FingerType: [CGPoint]]
    let wrist: CGPoint?
    let chirality: HandChirality
    
    // Calculate nail position and orientation for a finger
    func getNailTransform(for finger: FingerType, viewSize: CGSize) -> NailTransform? {
        guard let tipPoint = fingerTips[finger],
              let joints = fingerJoints[finger],
              joints.count >= 2 else {
            return nil
        }
        
        // Convert normalized coordinates to view coordinates
        let tip = CGPoint(x: tipPoint.x * viewSize.width, y: (1 - tipPoint.y) * viewSize.height)
        let dip = CGPoint(x: joints[0].x * viewSize.width, y: (1 - joints[0].y) * viewSize.height)
        
        // Calculate direction vector
        let dx = tip.x - dip.x
        let dy = tip.y - dip.y
        let angle = atan2(dy, dx)
        
        // Calculate nail size based on finger segment length
        let distance = sqrt(dx * dx + dy * dy)
        let nailWidth = distance * 0.6
        let nailHeight = distance * 0.8
        
        // Position nail slightly before the fingertip
        let offsetRatio: CGFloat = 0.7
        let nailX = dip.x + dx * offsetRatio
        let nailY = dip.y + dy * offsetRatio
        
        return NailTransform(
            position: CGPoint(x: nailX, y: nailY),
            rotation: angle,
            scale: CGSize(width: nailWidth, height: nailHeight)
        )
    }
}

struct NailTransform {
    let position: CGPoint
    let rotation: CGFloat // in radians
    let scale: CGSize
}
