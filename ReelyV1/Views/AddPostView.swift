//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct AddPostView: View {
    @Binding var pickerResult: UIImage
    @Binding var showYPImagePickerView: Bool
    
    @State private var isShowPhotoLibrary = false
    @State var postTitle: String = ""
    @State var postBody: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.showYPImagePickerView = true
            }) {
                Image(systemName: "xmark")
                        .font(.system(size: 24))
            }.padding(.bottom)
            Text("Photo:")
            Image(uiImage: pickerResult)
                    .resizable()
                    .scaledToFit()
            Text("Title: (limit 20 characters)")
            TextField("Title", text: $postTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Body: (minimum 50 characters)")
            TextEditor(text: $postBody)
                .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray).opacity(0.5))
            Spacer()
            Button(action: {
                self.showYPImagePickerView = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        
                    Text("Submit")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }.padding(.top, 40)
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }.padding()
    }
}

//struct AddPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPostView()
//    }
//}
