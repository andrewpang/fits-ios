//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct AddPostView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    @Binding var pickerResult: UIImage
    @Binding var showYPImagePickerView: Bool
    @Binding var tabSelection: Int
    
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
                homeViewModel.addPost(image: pickerResult, author: "andrew", body: postBody, title: postTitle, likes: 0)
                homeViewModel.isLoading = true
                resetPostView()
            }) {
                HStack {
                    if (homeViewModel.isLoading) {
                        Image(systemName: "clock.arrow.2.circlepath")
                            .font(.system(size: 20))
                        Text("Loading...")
                            .font(.headline)
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                        Text("Submit")
                            .font(.headline)
                    }
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
    
    func resetPostView() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.tabSelection = 1
        showYPImagePickerView = true
        self.postTitle = ""
        self.postBody = ""
        homeViewModel.isLoading = false
    }
}

//struct AddPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPostView()
//    }
//}
