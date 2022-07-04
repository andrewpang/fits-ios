//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import FirebaseAuth

struct AddPostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @EnvironmentObject var tabViewModel: TabViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack (alignment: .leading) {
                    Group {
                        Text("Photo:").font(Font.system(size: 24)).bold()
                        if let postImage = postViewModel.postImage  {
                            Image(uiImage: postImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                        }
                        
                        Text("Title:").bold()
                        Text("Choose a title for your post (maximum 20 characters)").font(Font.system(size: 14)).foregroundColor(.gray)
                        TextField("Title", text: $postViewModel.postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Text("✍️ Post:")
                    Text("Tell us what you think! What do you like/dislike about the product? Who is this product for/not for?").font(Font.system(size: 14)).foregroundColor(.gray)
                    TextEditor(text: $postViewModel.postBody)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray).opacity(0.3))
                            .frame(minHeight: 150)
                }
                Spacer()
                Button(action: {
                    let postAuthorMap = PostAuthorMap(displayName: authenticationViewModel.userModel?.displayName, profilePicImageUrl: authenticationViewModel.userModel?.profilePicImageUrl, userId: authenticationViewModel.userModel?.id)
                    postViewModel.submitPost(postAuthorMap: postAuthorMap)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        postViewModel.shouldPopToRootViewIfFalse = false
                        tabViewModel.tabSelection = 1
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    HStack {
                        if (postViewModel.isSubmitting) {
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
                .disabled(self.postViewModel.isSubmitting)
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }.padding()
    }
}

//struct AddPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPostView(homeViewModel: <#T##HomeViewModel#>, authenticationViewModel: <#T##AuthenticationViewModel#>, pickerResult: <#T##Binding<UIImage>#>)
//    }
//}
