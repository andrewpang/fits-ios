//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import FirebaseAuth

struct AddPostView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    @Binding var pickerResult: UIImage
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.homeViewModel.showYPImagePickerView = true
            }) {
                Image(systemName: "xmark")
                        .font(.system(size: 24))
            }.padding(.bottom)
            Text("Photo:")
            Image(uiImage: pickerResult)
                    .resizable()
                    .scaledToFit()
            Text("Title: (limit 20 characters)")
            TextField("Title", text: $homeViewModel.postTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Body: (minimum 50 characters)")
            TextEditor(text: $homeViewModel.postBody)
                .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray).opacity(0.5))
            Spacer()
            Button(action: {
                homeViewModel.addPost(image: pickerResult, author: Auth.auth().currentUser?.email ?? "nil", body: homeViewModel.postBody, title: homeViewModel.postTitle, likes: 0)
                homeViewModel.isLoading = true
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
            .disabled(self.homeViewModel.isLoading)
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }.padding()
            .navigationBarHidden(true)
    }
}

//struct AddPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPostView()
//    }
//}
