//
//  DraggableImageView.swift
//  MDB-Project
//
//  Created by Brayton Lordianto and Amol Budhiraja on 9/30/24.
//

import SwiftUI

class DraggableImageView: UIImageView {
    var beganPoint: CGPoint? = nil
    var originCenter: CGPoint? = nil

    override init(image: UIImage?) {
        super.init(image: image)
        setupGestureRecognizers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        
        self.isUserInteractionEnabled = true
        
        // Set up gesture recognizers for pinch, rotate, and long press
        let pinchRecog = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotateRecog = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let longPressRecog = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        self.addGestureRecognizer(pinchRecog)
        self.addGestureRecognizer(rotateRecog)
        self.addGestureRecognizer(longPressRecog)
        
    }

    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let view = gestureRecognizer.view else {return}
        
            
        if gestureRecognizer.state == .changed {
            view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        }
        gestureRecognizer.scale = 1
        
        
    }

    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        // Implement rotation logic
        
        guard let view = gestureRecognizer.view else {return}
        
        if gestureRecognizer.state == .changed {
            view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
        }
        
        gestureRecognizer.rotation = 0
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        // Implement long press logic to remove image
        guard let view = gestureRecognizer.view else {return}
        
        if gestureRecognizer.state == .began {
            view.removeFromSuperview()
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Capture the initial touch point
        super.touchesBegan(touches, with: event)
        if let touch = touches.first{
            beganPoint = touch.location(in: self.superview)
            originCenter = self.center
        }
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Implement logic for moving the image
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first,
              let beganPoint = self.beganPoint,
              let originCenter = self.originCenter else {
            return
        }
        let currentPoint = touch.location(in: self.superview)
        let deltaX = currentPoint.x - beganPoint.x
        let deltaY = currentPoint.y - beganPoint.y
        let newCenter = CGPoint(x: originCenter.x + deltaX, y: originCenter.y + deltaY)
        self.center = newCenter
    }
}
