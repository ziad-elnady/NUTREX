//
//  QRFoodScannerScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 25/04/2024.
//

import AVKit
import SwiftUI

struct QRFoodScannerScreen: View {
    enum Permession: String {
        case idle       = "Not Determined"
        case approved   = "Access Granted"
        case denied     = "Access Denied"
    }
    
    @Environment(\.openURL) private var openUrl
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var qrDelegate = QRScannerCoordinator()
    
    @State private var camSession: AVCaptureSession = AVCaptureSession()
    @State private var camOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    @State private var cameraPermission: Permession = .idle
    
    @State private var isScanning: Bool = false
    @State private var scannedCode: String = ""
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .bodyFontStyle()
            }
            .background {
                Circle()
                    .fill(Color.nxCard)
                    .frame(width: 50.0, height: 50.0)
            }
            .foregroundStyle(.primary)
            .frame(width: 50.0, height: 50.0)
            .hSpacing(.trailing)
            .padding(.trailing)
            
            Text("Place the QR Code inside the area")
                .bodyFontStyle()
                .foregroundStyle(.primary)
                .padding(.top, 32.0)
            
            Text("Scanning will start automatically")
                .captionFontStyle()
                .foregroundStyle(.secondary)
            
            Spacer(minLength: 0.0)
            
            GeometryReader {
                let size = $0.size
                
                ZStack(alignment: .center) {
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90.0
                        
                        RoundedRectangle(cornerRadius: 2.0, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(rotation))
                    }
                    
                    CameraView(frameSize: .init(width: size.width, height: size.width), session: $camSession)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .scaleEffect(0.9, anchor: .center)
                }
                /// Square shape.
                .frame(width: size.width, height: size.width)
                /// Scanner animation
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.black.opacity(0.1),
                                        Color(.nxAccent),
                                        Color.black.opacity(0.1)
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2.0)
                        .shadow(color: .black.opacity(0.5), radius: 16.0, x: 0, y: 16.0)
                        .offset(y: isScanning ? size.width : 0)
                        .onAppear {
                            startScannerAnimation()
                        }
                }
                /// Take all avalilable space
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45.0)
            
            Spacer(minLength: 15.0)
            
            Button {
                if camSession.isRunning && cameraPermission == .approved {
                    reActivateCamera()
                    startScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundStyle(.nxBackground)
                    .padding()
                    .background {
                        Circle()
                            .fill(Color(.nxAccent))
                    }
            }
            
            Spacer(minLength: 45.0)
        }
        .onAppear(perform: checkCameraPermession)
        .onDisappear {
            camSession.stopRunning()
        }
        .alert(errorMessage ?? "Oops!", isPresented: Binding(value: $errorMessage)) {
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsUrlString = UIApplication.openSettingsURLString
                    if let settingsUrl = URL(string: settingsUrlString) {
                        openUrl(settingsUrl)
                    }
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .onChange(of: qrDelegate.scannedCode) { _ , newValue in
            if let code = newValue {
                scannedCode = code
                /// Whenever code is read stop the camera immediatly preventing multiple code reads
                camSession.stopRunning()
                stopScannerAnimation()
            }
        }
    }
    
    private func startScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    private func stopScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    private func checkCameraPermession() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    if camSession.inputs.isEmpty {
                        setupCamera()
                    } else {
                        reActivateCamera()
                    }
                } else {
                    cameraPermission = .denied
                    errorMessage = "Access Denied!"
                }
            case .denied, .restricted:
                cameraPermission = .denied
                errorMessage = "Access Denied!"
            case .authorized:
                cameraPermission = .approved
                setupCamera()
            default: break
            }
        }
    }
    
    private func setupCamera() {
        do {
            /// Finding back camera.
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                    mediaType: .video,
                                                                    position: .back).devices.first else {
                errorMessage = "UNKNOWN ERROR!"
                return
            }
            
            /// Camera input.
            let input = try AVCaptureDeviceInput(device: device)
            /// For extra saftey
            /// Checking whether input & output can be added to the session
            guard camSession.canAddInput(input), camSession.canAddOutput(camOutput) else {
                errorMessage = "UNKNOWN ERROR!"
                return
            }
            
            camSession.beginConfiguration()
            camSession.addInput(input)
            camSession.addOutput(camOutput)
            /// Setting output config to read qr codes.
            camOutput.metadataObjectTypes = [.qr]
            /// Adding delegate to retreive the fetched QR Code from the Camera
            camOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            
            camSession.commitConfiguration()
            /// Note that session  MUST be started on background thread
            DispatchQueue.global(qos: .background).async {
                camSession.startRunning()
            }
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
    
    private func reActivateCamera() {
        DispatchQueue.global(qos: .background).async {
            camSession.startRunning()
        }
    }
}
    
class QRScannerCoordinator: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            scannedCode = code
        }
    }
}
//    private func checkCameraPermission() {
//        Task {
//            await MainActor.run {
//                switch AVCaptureDevice.authorizationStatus(for: .video) {
//                case .notDetermined:
//                    if await AVCaptureDevice.requestAccess(for: .video) {
//                        cameraPermission = .approved
//                    } else {
//                        cameraPermission = .denied
//                    }
//                case .denied, .restricted:
//                    cameraPermission = .denied
//                    alert = .dataNotFound(onRetryPressed: {
//                        openSettings()
//                    })
//                case .authorized:
//                    cameraPermission = .approved
//                default:
//                    break
//                }
//            }
//        }
//    }
//
//    // Function to open settings
//    private func openSettings() {
//        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//            openURL(settingsURL)
//        }
//    }
//
//    // Helper function to open URL
//    private func openURL(_ url: URL) {
//        UIApplication.shared.open(url)
//    }

#Preview {
    QRFoodScannerScreen()
}

struct CameraView: UIViewRepresentable {
    var frameSize: CGSize
    
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) ->  UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        
        view.layer.addSublayer(cameraLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
