//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct AddPostView: View {
    @State var pickerResult: UIImage = UIImage(named: "placeHolder")!
    @State private var isShowPhotoLibrary = false
    @State var postTitle: String = ""
    @State var postBody: String = "Enter your post here"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Title:")
                TextField("Title", text: $postTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Body:")
                TextEditor(text: $postBody)
                    .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray).opacity(0.5))

                Text("Image:")
                Image(uiImage: pickerResult)
                        .resizable()
                        .scaledToFit()
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
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                
                Spacer()
                Button(action: {
    //                self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            
                        Text("Submit")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }.padding(.top, 40)
            }
            .navigationTitle("Add Post")
            .padding()
            .sheet(isPresented: $isShowPhotoLibrary) {
                PhotoPicker(pickerResult: $pickerResult,
                                    isPresented: $isShowPhotoLibrary)
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
