//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct AddPostView: View {
    @State var pickerResult: [UIImage] = []
    @State private var isShowPhotoLibrary = false
    
    var body: some View {
        VStack {
            HStack {
                ForEach(pickerResult, id: \.self) { uiImage in
                  Image(uiImage: uiImage)
                }
                .padding()
            }
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                        
                    Text("Photo library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            PhotoPicker(pickerResult: $pickerResult,
                                isPresented: $isShowPhotoLibrary)
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
