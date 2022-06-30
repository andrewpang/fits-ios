//
//  PhotoPicker.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import PhotosUI

struct PhotoGalleryPicker: UIViewControllerRepresentable {
  @Binding var pickerResult: UIImage?
  @Binding var isPresented: Bool
  
  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    configuration.filter = .images // filter only to images
    configuration.selectionLimit = 1
    
    let photoPickerViewController = PHPickerViewController(configuration: configuration)
    photoPickerViewController.delegate = context.coordinator
    return photoPickerViewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PhotoGalleryPicker
    
    init(_ parent: PhotoGalleryPicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for image in results {
            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
              image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                if let error = error {
                  print("Can't load image \(error.localizedDescription)")
                } else if let image = newImage as? UIImage {
                    DispatchQueue.main.async {
                        self?.parent.pickerResult = image
                    }
                }
              }
            } else {
              print("Can't load asset")
            }
        }
        DispatchQueue.main.async {
            self.parent.isPresented = false
        }
    }
  }
}
