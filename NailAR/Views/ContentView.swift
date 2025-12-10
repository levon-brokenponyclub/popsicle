//
//  ContentView.swift
//  NailAR
//
//  Main view controller for the nail AR app
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var selectedStyle: NailStyle = .natural
    @State private var showStylePicker = false
    @State private var capturePhoto = false
    
    var body: some View {
        ZStack {
            // AR Camera View (full screen)
            ARCameraView(
                cameraManager: cameraManager,
                selectedStyle: $selectedStyle,
                capturePhoto: $capturePhoto
            )
            .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            VStack {
                Spacer()
                
                HStack(spacing: 20) {
                    // Style Picker Button
                    Button(action: {
                        withAnimation {
                            showStylePicker.toggle()
                        }
                    }) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.pink.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    // Capture Button
                    Button(action: {
                        capturePhoto = true
                    }) {
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 70, height: 70)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                        }
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    // Camera Switch Button
                    Button(action: {
                        cameraManager.switchCamera()
                    }) {
                        Image(systemName: "camera.rotate.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            
            // Style Picker Overlay
            if showStylePicker {
                VStack {
                    Spacer()
                    NailStylePickerView(selectedStyle: $selectedStyle, isPresented: $showStylePicker)
                        .transition(.move(edge: .bottom))
                        .frame(height: 200)
                }
            }
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    ContentView()
}
