//
//  PhotoPicker.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import PhotosUI

struct PHImagePicker: UIViewControllerRepresentable {    
    @ObservedObject var mediaItems: PickedMediaItems
    var didFinishPicking: (_ didSelectItems: Bool) -> Void
    
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images // filter only to images
        configuration.selection = .ordered
        configuration.selectionLimit = 5
        configuration.preferredAssetRepresentationMode = .current
    
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PHImagePicker
    
    init(_ parent: PHImagePicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        parent.didFinishPicking(!results.isEmpty)
        
        guard !results.isEmpty else {
            return
        }
        
        parent.mediaItems.items = Array(repeating: PhotoPickerModel(with: nil), count: results.count)
        
        for (index, result) in results.enumerated() {
            let itemProvider = result.itemProvider
            
            guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier)
            else { continue }
            
            if utType.conforms(to: .image) {
                self.getPhoto(from: itemProvider, isLivePhoto: false, indexOfImage: index)
            } else if utType.conforms(to: .movie) {
                // Do nothing for now with videos
//                self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
            } else {
                //For now, just pull UIImage from Live Photos
                self.getPhoto(from: itemProvider, isLivePhoto: false, indexOfImage: index)
            }
        }
    }
      
      private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool, indexOfImage: Int) {
          let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
                  
          if itemProvider.canLoadObject(ofClass: objectType) {
              let progress: Progress?
              progress = itemProvider.loadObject(ofClass: objectType) { object, error in
                  if let error = error {
                      print(error.localizedDescription)
                  }
                          
                  if !isLivePhoto {
                      if let image = object as? UIImage {
                          DispatchQueue.main.async {
                              self.parent.mediaItems.addForIndex(item: PhotoPickerModel(with: image), index: indexOfImage)
                          }
                      }
                  } else {
                      if let livePhoto = object as? PHLivePhoto {
                          DispatchQueue.main.async {
                              self.parent.mediaItems.addForIndex(item: PhotoPickerModel(with: livePhoto), index: indexOfImage)
                          }
                      }
                  }
              }
          }
      }
      
      private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
//          itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
//              if let error = error {
//                  print(error.localizedDescription)
//              }
//
//              guard let url = url else { return }
//
//              let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//              guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
//
//              do {
//                  if FileManager.default.fileExists(atPath: targetURL.path) {
//                      try FileManager.default.removeItem(at: targetURL)
//                  }
//
//                  try FileManager.default.copyItem(at: url, to: targetURL)
//
//                  DispatchQueue.main.async {
//                      self.parent.mediaItems.append(item: PhotoPickerModel(with: targetURL))
//                  }
//              } catch {
//                  print(error.localizedDescription)
//              }
//          }
      }
  }
}
