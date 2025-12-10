//
//  NailStylePickerView.swift
//  NailAR
//
//  Scrollable picker for selecting nail designs
//

import SwiftUI

struct NailStylePickerView: View {
    @Binding var selectedStyle: NailStyle
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Choose Your Style")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(Color.black.opacity(0.8))
            
            // Scrollable style grid
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(NailStyle.allCases) { style in
                        NailStyleCard(
                            style: style,
                            isSelected: selectedStyle == style
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedStyle = style
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            .background(Color.black.opacity(0.9))
        }
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 20)
    }
}

struct NailStyleCard: View {
    let style: NailStyle
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // Preview oval (nail shape)
            ZStack {
                if let secondaryColor = style.secondaryColor {
                    // Gradient
                    LinearGradient(
                        colors: [style.primaryColor, secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 70, height: 90)
                    .clipShape(NailShape())
                } else {
                    style.primaryColor
                        .frame(width: 70, height: 90)
                        .clipShape(NailShape())
                }
                
                // Add effects overlay
                if style.hasGlitter || style.metallic {
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.clear,
                            Color.white.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 70, height: 90)
                    .clipShape(NailShape())
                }
                
                // Selection indicator
                if isSelected {
                    NailShape()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 70, height: 90)
                }
            }
            .shadow(color: isSelected ? .white.opacity(0.5) : .black.opacity(0.3), radius: isSelected ? 8 : 4)
            
            // Style name
            Text(style.displayName)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 80)
                .lineLimit(2)
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// Custom nail shape
struct NailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Create an oval nail shape with slightly flattened top
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        
        // Top curve
        path.addQuadCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control: CGPoint(x: width * 0.9, y: height * 0.1)
        )
        
        // Right side
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control: CGPoint(x: width * 1.1, y: height * 0.7)
        )
        
        // Left side
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height * 0.3),
            control: CGPoint(x: -width * 0.1, y: height * 0.7)
        )
        
        // Top left curve
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control: CGPoint(x: width * 0.1, y: height * 0.1)
        )
        
        return path
    }
}

// Extension for selective corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ZStack {
        Color.gray.edgesIgnoringSafeArea(.all)
        
        VStack {
            Spacer()
            NailStylePickerView(
                selectedStyle: .constant(.classic),
                isPresented: .constant(true)
            )
            .frame(height: 200)
        }
    }
}
