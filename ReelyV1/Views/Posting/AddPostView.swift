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
    
    @Binding var pickerResult: UIImage?
    
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
                        Image(uiImage: pickerResult!)
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
                        Text("💄 What brand is it from?")
                        TextField("Brand name", text: $homeViewModel.postBrandName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("🧴 What is the product name?")
                        TextField("Product name", text: $homeViewModel.postProductName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("🏷 How much did it cost?")
                        TextField("Price", text: $homeViewModel.postPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
//                        Text("What do I love about it?")
//                        TextField("(Optional Answer)", text: $homeViewModel.postLoveAboutIt)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
//                    Group {
//                        Text("What don't I like about it?")
//                        TextField("(Optional Answer)", text: $homeViewModel.postDislikeAbout)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                        Text("Who is this product for?")
//                        TextField("(Optional Answer)", text: $homeViewModel.postWhoFor)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                        Text("Who should avoid this product?")
//                        TextField("(Optional Answer)", text: $homeViewModel.postWhoNotFor)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
                    Text("✍️ Your Review:")
                    Text("Tell us what you think! What do you like/dislike about the product? Who is this product for/not for?").font(Font.system(size: 14)).foregroundColor(.gray)
                    TextEditor(text: $homeViewModel.postBody)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray).opacity(0.3))
                            .frame(minHeight: 150)
                    
                }
                Spacer()
                Button(action: {
                    homeViewModel.addPost(image: pickerResult!, author: authenticationViewModel.displayName, likes: 0, brandName: homeViewModel.postBrandName, productName: homeViewModel.postProductName, price: homeViewModel.postPrice, body: homeViewModel.postBody)
                    
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
            }
            
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
