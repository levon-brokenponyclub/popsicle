//
//  NailStyle.swift
//  NailAR
//
//  Model for nail design styles
//

import Foundation
import SwiftUI

enum NailStyle: String, CaseIterable, Identifiable {
    case classic = "Classic French"
    case glitter = "Glitter Gold"
    case red = "Ruby Red"
    case pink = "Baby Pink"
    case blue = "Ocean Blue"
    case purple = "Royal Purple"
    case gradient = "Sunset Gradient"
    case chrome = "Chrome Silver"
    case matte = "Matte Black"
    case floral = "Floral Design"
    case geometric = "Geometric Pattern"
    case holographic = "Holographic"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return rawValue
    }
    
    // Primary color for the nail design
    var primaryColor: Color {
        switch self {
        case .classic:
            return Color(red: 1.0, green: 0.95, blue: 0.9)
        case .glitter:
            return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .red:
            return Color(red: 0.8, green: 0.0, blue: 0.0)
        case .pink:
            return Color(red: 1.0, green: 0.75, blue: 0.8)
        case .blue:
            return Color(red: 0.0, green: 0.5, blue: 0.8)
        case .purple:
            return Color(red: 0.5, green: 0.0, blue: 0.5)
        case .gradient:
            return Color(red: 1.0, green: 0.5, blue: 0.3)
        case .chrome:
            return Color(red: 0.75, green: 0.75, blue: 0.75)
        case .matte:
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        case .floral:
            return Color(red: 1.0, green: 0.9, blue: 0.95)
        case .geometric:
            return Color(red: 0.3, green: 0.7, blue: 0.9)
        case .holographic:
            return Color(red: 0.9, green: 0.7, blue: 1.0)
        }
    }
    
    // Secondary color for gradient/accent
    var secondaryColor: Color? {
        switch self {
        case .gradient:
            return Color(red: 0.8, green: 0.2, blue: 0.5)
        case .classic:
            return Color.white
        case .holographic:
            return Color(red: 0.5, green: 0.9, blue: 1.0)
        default:
            return nil
        }
    }
    
    // Visual properties
    var hasGlitter: Bool {
        return self == .glitter || self == .holographic
    }
    
    var hasPattern: Bool {
        return self == .floral || self == .geometric
    }
    
    var isMatte: Bool {
        return self == .matte
    }
    
    var metallic: Bool {
        return self == .chrome || self == .glitter
    }
}
