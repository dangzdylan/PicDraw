//
//  DrawingViewModel.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import Foundation
import UIKit
import PencilKit

struct DrawingModel {
    var canvas: PKCanvasView
    var name: String
    var isSelected: Bool = false
    var overlaidImages = [overlaidImage]()
    var idImage = UIImage()

    struct overlaidImage {
        var image: UIImage
        var center: CGPoint
        var scale: CGFloat
        var rotation: CGFloat
    }

    init() {
        self.canvas = .init()
        self.name = "untitled"
    }
}

extension DrawingModel {
    mutating func overlayImage(image: UIImage) -> DrawingModel {
        var newModel = self
        let newImage = overlaidImage(image: image, center: canvas.center, scale: 1.0, rotation: 0)
        newModel.overlaidImages.append(newImage)

        let imageView = DraggableImageView(image: image)
        imageView.center = canvas.center
        newModel.canvas.addSubview(imageView)
        return newModel
    }
    
    func createExportableView() -> UIView {
        // Implement logic to capture the canvas and create a snapshot image
        let containerView = UIView(frame: canvas.bounds)
        containerView.addSubview(canvas)
        
        for overlaidImage in overlaidImages {
            let imageView = UIImageView(image: overlaidImage.image)
            imageView.center = overlaidImage.center
            
            
            let scaleTransform = CGAffineTransform(scaleX: overlaidImage.scale, y: overlaidImage.scale)
            let rotatedTransform = scaleTransform.rotated(by: overlaidImage.rotation)
            imageView.transform = rotatedTransform
            containerView.addSubview(imageView)
        }
        
        return containerView

    }
    
}

class DrawingViewModel: ObservableObject {
    @Published var drawing = DrawingModel()
    
    func addImageToCanvas(image: UIImage) {
        self.drawing = drawing.overlayImage(image: image)  // Properly update the model
    }
}
