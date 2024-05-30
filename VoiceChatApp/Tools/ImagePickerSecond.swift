//
//  ImagePickerSecond.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/26.
//

import Foundation
import PhotosUI
import SwiftUI


struct ImagePickerSecond: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        return ImagePickerSecond.Coordinator(parent1: self)
    }
    
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    var selectionLimit: Int = 1
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerSecond
        
        init(parent1: ImagePickerSecond) {
            self.parent = parent1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.picker.toggle()
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    img.itemProvider.loadObject(ofClass: UIImage.self) { (image, err) in
                        DispatchQueue.main.async {
                            guard let image1 = image else {
                                print("Image Picker Error: \(err)")
                                return
                            }
                            self.parent.images.append(image as! UIImage)
                        }
                    }
                }
                else {
                    print("cannot be loaded")
                }
            }
        }
        
    }
    
}
