//
//  MediaPicker.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/27/22.
//

import SwiftUI
import YPImagePicker

struct MediaPicker: UIViewControllerRepresentable {
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var pickerResult: UIImage
    
    func makeUIViewController(context: Context) -> YPImagePicker {
        let config = YPImagePickerConfiguration()
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage ?? "not modified !") // Transformed image, can be nil
                print(photo.exifMeta ?? "no exif metadata") // Print exif meta data of original image."
                pickerResult = photo.image
                homeViewModel.showYPImagePickerView = false
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {}
    
    typealias UIViewControllerType = YPImagePicker
    
}
