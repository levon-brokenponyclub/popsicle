//
//  NailOverlayRenderer.swift
//  NailAR
//
//  Renders nail overlays on detected fingertips
//

import UIKit
import SwiftUI

class NailOverlayRenderer {
    private weak var containerView: UIView?
    private var nailViews: [String: UIView] = [:]
    private var previousTransforms: [String: NailTransform] = [:]
    
    init(view: UIView) {
        self.containerView = view
    }
    
    func updateNailOverlays(hands: [HandLandmarks], style: NailStyle, viewSize: CGSize) {
        guard !hands.isEmpty else {
            clearNailViews()
            return
        }

        var keysInUse = Set<String>()

        // Render nails for each detected hand
        for (handIndex, hand) in hands.enumerated() {
            renderNailsForHand(hand, handIndex: handIndex, style: style, viewSize: viewSize, keysInUse: &keysInUse)
        }

        // Remove any overlays that were not updated this frame
        pruneUnusedNails(keeping: keysInUse)
    }
    
    private func renderNailsForHand(_ hand: HandLandmarks, handIndex: Int, style: NailStyle, viewSize: CGSize, keysInUse: inout Set<String>) {
        for finger in FingerType.allCases {
            guard let transform = hand.getNailTransform(for: finger, viewSize: viewSize) else {
                continue
            }
            
            let key = "\(handIndex)_\(finger.rawValue)"
            keysInUse.insert(key)
            let nailView = createOrUpdateNailView(key: key, transform: transform, style: style)
            
            if nailView.superview == nil {
                containerView?.addSubview(nailView)
            }
        }
    }
    
    private func createOrUpdateNailView(key: String, transform: NailTransform, style: NailStyle) -> UIView {
        let nailView: UIView
        
        if let existing = nailViews[key] {
            nailView = existing
        } else {
            nailView = UIView()
            nailView.layer.cornerRadius = 8
            nailView.layer.masksToBounds = true
            nailViews[key] = nailView
        }

        let smoothed = smoothTransform(for: key, newTransform: transform)
        previousTransforms[key] = smoothed
        
        // Apply transform
        nailView.bounds = CGRect(origin: .zero, size: smoothed.scale)
        nailView.center = smoothed.position
        nailView.transform = CGAffineTransform(rotationAngle: smoothed.rotation)
        
        // Apply style
        applyStyle(to: nailView, style: style)
        
        return nailView
    }

    private func smoothTransform(for key: String, newTransform: NailTransform, alpha: CGFloat = 0.25) -> NailTransform {
        guard let previous = previousTransforms[key] else { return newTransform }
        let invAlpha: CGFloat = 1 - alpha
        let position = CGPoint(x: previous.position.x * invAlpha + newTransform.position.x * alpha,
                               y: previous.position.y * invAlpha + newTransform.position.y * alpha)
        let scale = CGSize(width: previous.scale.width * invAlpha + newTransform.scale.width * alpha,
                           height: previous.scale.height * invAlpha + newTransform.scale.height * alpha)

        // Smooth rotation using shortest angular distance
        let delta = shortestAngleDelta(from: previous.rotation, to: newTransform.rotation)
        let rotation = previous.rotation + delta * alpha

        return NailTransform(position: position, rotation: rotation, scale: scale)
    }

    private func shortestAngleDelta(from: CGFloat, to: CGFloat) -> CGFloat {
        var delta = to - from
        while delta > .pi { delta -= 2 * .pi }
        while delta < -.pi { delta += 2 * .pi }
        return delta
    }
    
    private func applyStyle(to view: UIView, style: NailStyle) {
        // Remove existing sublayers/subviews
        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Base color
        view.backgroundColor = UIColor(style.primaryColor)
        
        // Add effects based on style
        if let secondaryColor = style.secondaryColor {
            // Add gradient
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [
                UIColor(style.primaryColor).cgColor,
                UIColor(secondaryColor).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        // Add shine/glitter effect
        if style.hasGlitter {
            addGlitterEffect(to: view)
        }
        
        // Add metallic shine
        if style.metallic {
            addMetallicEffect(to: view)
        }
        
        // Add pattern overlay
        if style.hasPattern {
            addPatternOverlay(to: view, style: style)
        }
        
        // Matte finish (no shine)
        if style.isMatte {
            view.layer.opacity = 0.95
        } else {
            // Add glossy shine effect
            addGlossEffect(to: view)
        }
        
        // Add subtle border
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
    
    private func addGlitterEffect(to view: UIView) {
        let glitterLayer = CALayer()
        glitterLayer.frame = view.bounds
        glitterLayer.backgroundColor = UIColor.white.withAlphaComponent(0.4).cgColor
        
        // Create shimmer effect
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.3
        animation.toValue = 0.7
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        glitterLayer.add(animation, forKey: "glitter")
        view.layer.addSublayer(glitterLayer)
    }
    
    private func addMetallicEffect(to view: UIView) {
        let metallicLayer = CAGradientLayer()
        metallicLayer.frame = view.bounds
        metallicLayer.colors = [
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.4).cgColor
        ]
        metallicLayer.locations = [0, 0.5, 1]
        metallicLayer.startPoint = CGPoint(x: 0, y: 0)
        metallicLayer.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.addSublayer(metallicLayer)
    }
    
    private func addGlossEffect(to view: UIView) {
        let glossLayer = CAGradientLayer()
        glossLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.4)
        glossLayer.colors = [
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        glossLayer.locations = [0, 1]
        
        view.layer.addSublayer(glossLayer)
    }
    
    private func addPatternOverlay(to view: UIView, style: NailStyle) {
        switch style {
        case .floral:
            addFloralPattern(to: view)
        case .geometric:
            addGeometricPattern(to: view)
        default:
            break
        }
    }
    
    private func addFloralPattern(to view: UIView) {
        // Simple floral dots pattern
        let patternSize: CGFloat = 4
        let spacing: CGFloat = 8
        
        for x in stride(from: spacing, to: view.bounds.width, by: spacing) {
            for y in stride(from: spacing, to: view.bounds.height, by: spacing) {
                let dot = CAShapeLayer()
                dot.path = UIBezierPath(ovalIn: CGRect(x: x - patternSize/2, y: y - patternSize/2, width: patternSize, height: patternSize)).cgPath
                dot.fillColor = UIColor.white.withAlphaComponent(0.4).cgColor
                view.layer.addSublayer(dot)
            }
        }
    }
    
    private func addGeometricPattern(to view: UIView) {
        // Simple stripe pattern
        let stripeWidth: CGFloat = 3
        let spacing: CGFloat = 6
        
        for x in stride(from: 0, to: view.bounds.width, by: stripeWidth + spacing) {
            let stripe = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: view.bounds.height))
            stripe.path = path.cgPath
            stripe.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
            stripe.lineWidth = stripeWidth
            view.layer.addSublayer(stripe)
        }
    }
    
    private func clearNailViews() {
        for (_, view) in nailViews {
            view.removeFromSuperview()
        }
        nailViews.removeAll()
        previousTransforms.removeAll()
    }

    private func pruneUnusedNails(keeping keys: Set<String>) {
        let unusedKeys = nailViews.keys.filter { !keys.contains($0) }
        for key in unusedKeys {
            nailViews[key]?.removeFromSuperview()
            nailViews.removeValue(forKey: key)
            previousTransforms.removeValue(forKey: key)
        }
    }
}
