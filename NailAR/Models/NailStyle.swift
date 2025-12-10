//
//  NailStyle.swift
//  NailAR
//
//  Model for nail design styles
//

import Foundation
import SwiftUI

enum NailStyle: String, CaseIterable, Identifiable {
    case natural = "Natural Clear"
    case nude = "Soft Nude"
    case blush = "Blush Pink"
    case cherry = "Cherry Red"
    case coral = "Coral"
    case sky = "Sky Blue"
    case lilac = "Lilac"
    case emerald = "Emerald"
    case slate = "Slate Matte"
    case betaSunrise = "Beta: Sunrise"
    case betaLagoon = "Beta: Lagoon"
    case betaAmethyst = "Beta: Amethyst"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return rawValue
    }
    
    // Primary color for the nail design
    var primaryColor: Color {
        switch self {
        case .natural:
            return Color(red: 1.0, green: 1.0, blue: 1.0).opacity(0.25)
        case .nude:
            return Color(red: 0.93, green: 0.84, blue: 0.78)
        case .blush:
            return Color(red: 1.0, green: 0.78, blue: 0.86)
        case .cherry:
            return Color(red: 0.84, green: 0.09, blue: 0.17)
        case .coral:
            return Color(red: 1.0, green: 0.52, blue: 0.47)
        case .sky:
            return Color(red: 0.38, green: 0.69, blue: 0.97)
        case .lilac:
            return Color(red: 0.74, green: 0.62, blue: 0.91)
        case .emerald:
            return Color(red: 0.13, green: 0.56, blue: 0.45)
        case .slate:
            return Color(red: 0.24, green: 0.27, blue: 0.32)
        case .betaSunrise:
            return Color(red: 1.0, green: 0.64, blue: 0.36)
        case .betaLagoon:
            return Color(red: 0.18, green: 0.65, blue: 0.73)
        case .betaAmethyst:
            return Color(red: 0.56, green: 0.34, blue: 0.71)
        }
    }
    
    // Secondary color for gradient/accent
    var secondaryColor: Color? {
        return nil
    }
    
    // Visual properties
    var hasGlitter: Bool {
        return false
    }
    
    var hasPattern: Bool {
        return false
    }
    
    var isMatte: Bool {
        return self == .slate
    }
    
    var metallic: Bool {
        return false
    }
}
