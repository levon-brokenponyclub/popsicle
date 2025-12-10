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
    
    init(view: UIView) {
        self.containerView = view
    }
    
    func updateNailOverlays(hands: [HandLandmarks], style: NailStyle, viewSize: CGSize) {
        // Clear old nail views
        clearNailViews()
        
        guard !hands.isEmpty else { return }
        
        // Render nails for each detected hand
        for (handIndex, hand) in hands.enumerated() {
            renderNailsForHand(hand, handIndex: handIndex, style: style, viewSize: viewSize)
        }
    }
    
    private func renderNailsForHand(_ hand: HandLandmarks, handIndex: Int, style: NailStyle, viewSize: CGSize) {
        for finger in FingerType.allCases {
            guard let transform = hand.getNailTransform(for: finger, viewSize: viewSize) else {
                continue
            }
            
            let key = "\(handIndex)_\(finger.rawValue)"
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
        
        // Apply transform
        nailView.bounds = CGRect(origin: .zero, size: transform.scale)
        nailView.center = transform.position
        nailView.transform = CGAffineTransform(rotationAngle: transform.rotation)
        
        // Apply style
        applyStyle(to: nailView, style: style)
        
        return nailView
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
    }
}
