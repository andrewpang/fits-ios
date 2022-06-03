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
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @Binding var pickerResult: UIImage
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.homeViewModel.showYPImagePickerView = true
            }) {
                Image(systemName: "xmark")
                        .font(.system(size: 24))
            }.padding(.bottom)
            ScrollView {
                VStack (alignment: .leading) {
                    Group {
                        Text("Photo:").font(Font.system(size: 24)).bold()
                        Image(uiImage: pickerResult)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
//                        Text("Title:").bold()
//                        Text("Choose a title for your post (maximum 20 characters)").font(Font.system(size: 14)).foregroundColor(.gray)
//                        TextField("Title", text: $homeViewModel.postTitle)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Text("Review Questions:").font(Font.system(size: 24)).bold().padding(.bottom)
                    Group {
                        Text("What brand is it from?")
                        TextField("Brand name", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("What is the product name?")
                        TextField("Product name", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("How much did it cost?")
                        TextField("Price", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("What do I love about it?")
                        TextField("(Optional Answer)", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Group {
                        Text("What do I not like about it?")
                        TextField("(Optional Answer)", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Who is this product for?")
                        TextField("(Optional Answer)", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Who should avoid this product?")
                        TextField("(Optional Answer)", text: $homeViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
//                Text("Post:").bold()
//                Text("Give a review of your product...").font(Font.system(size: 14)).foregroundColor(.gray)
//                TextEditor(text: $homeViewModel.postBody)
//                    .padding(4)
//                        .overlay(RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray).opacity(0.5))
            }
            Spacer()
            Button(action: {
                homeViewModel.addPost(image: pickerResult, author: authenticationViewModel.displayName, body: homeViewModel.postBody, title: homeViewModel.postTitle, likes: 0)
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
                        Text("Submit Post")
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
//        AddPostView(homeViewModel: <#T##HomeViewModel#>, authenticationViewModel: <#T##AuthenticationViewModel#>, pickerResult: <#T##Binding<UIImage>#>)
//    }
//}
