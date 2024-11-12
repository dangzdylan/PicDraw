//
//  CanvasView.swift
//  MDB-Project
//
//  Created by Brayton Lordianto and Amol Budhiraja on 9/30/24.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    @Binding var drawing: DrawingModel
    @State var imageToOverlay: UIImage? = nil
    @State var takingPhoto: Bool = false
    @State private var isShowingShareSheet = false
    @State private var imageToShare: UIImage? = nil

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                // Add buttons for camera, eraser, and export here
                Button("Camera") {
                    takingPhoto = true
                }
                Button("Eraser") {
                    drawing.canvas.drawing = PKDrawing()
                }
                Button("Export") {
                    let drawingImage = drawToImage()
                    imageToShare = drawingImage
                    isShowingShareSheet = true
                }
                Spacer()
            }

            DrawSpace(drawing: $drawing)
                .edgesIgnoringSafeArea(.top)
        }
        .sheet(isPresented: $takingPhoto) {
            // Display ImagePicker when the camera is tapped
            ImagePicker(image: $imageToOverlay)
                .onChange(of: imageToOverlay) { newImage, _ in
                    if let chosenImage = imageToOverlay {
                        drawing = drawing.overlayImage(image: chosenImage)
                    } else {
                        print("No image chosen.")
                    }
                    
                }
        }
        .sheet(isPresented: $isShowingShareSheet) {
            // Present the share sheet with the generated image
            if let imageToShare = imageToShare {
                ShareSheet(activityItems: [imageToShare])
            }
            
        }
        
    }
    
    private func drawToImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 600, height: 600))
        return renderer.image { context in
                // Render the canvas drawing into the current graphics context
                drawing.canvas.drawHierarchy(in: drawing.canvas.bounds, afterScreenUpdates: true)
                
                // Overlay Images
                for overlay in drawing.overlaidImages {
                    let imageView = UIImageView(image: overlay.image)
                    imageView.center = overlay.center
                    imageView.transform = CGAffineTransform(scaleX: overlay.scale, y: overlay.scale)
                        .rotated(by: overlay.rotation)
                    
                    // Draw the transformed image onto the context
                    imageView.layer.render(in: context.cgContext)
                }
            }
    }
}

// ShareSheet Struct to Present UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview Provider
#Preview {
    CanvasView(drawing: .constant(DrawingModel.init()))
}


