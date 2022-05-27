//
//  PostParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/27/22.
//

import SwiftUI

struct PostParentView: View {
    @State var pickerResult: UIImage = UIImage(named: "placeHolder")!
    @State private var showYPImagePickerView = true
    
    var body: some View {
        ZStack {
            AddPostView(pickerResult: $pickerResult, showYPImagePickerView: $showYPImagePickerView)
            if (showYPImagePickerView) {
                MediaPicker(pickerResult: $pickerResult, showYPImagePickerView: $showYPImagePickerView)
            }
        }
        
    }
}

struct PostParentView_Previews: PreviewProvider {
    static var previews: some View {
        PostParentView()
    }
}
