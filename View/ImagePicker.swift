//
//  ImagePicker.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Dismiss the picker and handle the selected image
            picker.dismiss(animated: true)
            
            guard let selected = results.first else {
                return
            }
            
            let prov = selected.itemProvider
            
            if prov.canLoadObject(ofClass: UIImage.self) {
                prov.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
            
            
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Configure the PHPicker to select images only
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        
        let pick = PHPickerViewController(configuration: config)
        pick.delegate = context.coordinator
        return pick
        
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
