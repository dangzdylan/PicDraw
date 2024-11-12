//
//  DrawSpace.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import SwiftUI
import PencilKit

struct DrawSpace: View {
    @Binding var drawing: DrawingModel
    @State var offset = CGPoint()

    var body: some View {
        VStack(alignment: .leading) {
            DrawingViewRepresentable(canvas: $drawing.canvas)
                .aspectRatio(contentMode: .fill)
        }
        .ignoresSafeArea()
    }
}

struct DrawingViewRepresentable : UIViewRepresentable {
    var canvas: Binding<PKCanvasView>
    var toolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.wrappedValue.backgroundColor = .black
        canvas.wrappedValue.drawingPolicy = .anyInput
        showToolPicker()
        return canvas.wrappedValue
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
    
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvas.wrappedValue)
        toolPicker.addObserver(canvas.wrappedValue)
        canvas.wrappedValue.becomeFirstResponder()
    }
}
