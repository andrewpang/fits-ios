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
    
    
    let postTitleCharacterLimit = 30
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Group {
                    Text("Photo:")
                        .font(Font.custom(Constants.titleFontBold, size: 16))
                    if let postImage = postViewModel.postImage  {
                        Image(uiImage: postImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                    }
                    
                    Text("Post Title:")
                        .font(Font.custom(Constants.titleFontBold, size: 16))
                    TextField("Max. 30 Characters", text: $postViewModel.postTitle)
                        .font(Font.custom(Constants.titleFont, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(postViewModel.postTitle.publisher.collect()) {
                            let s = String($0.prefix(postTitleCharacterLimit))
                            if postViewModel.postTitle != s {
                                postViewModel.postTitle = s
                            }
                          }
                }
                Text("Note:")
                    .font(Font.custom(Constants.titleFontBold, size: 16))
                ZStack {
                    TextEditor(text: $postViewModel.postBody)
                        .font(Font.custom(Constants.bodyFont, size: 16))
                    Text(postViewModel.postBody).opacity(0).padding(.all, 8)
                        .font(Font.custom(Constants.bodyFont, size: 16))
                }
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray).opacity(0.3))
                .frame(minHeight: 100)
//                TextEditor(text: $postViewModel.postBody)
//                    .font(Font.custom(Constants.bodyFont, size: 16))
//                    .overlay(RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray).opacity(0.3))
//                    .frame(minHeight: 150)
                Text("Recommended Details:")
                    .font(Font.custom(Constants.bodyFont, size: 18))
                Text(postViewModel.recommendedDetails)
                    .font(Font.custom(Constants.bodyFont, size: 16))
            }
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Button("Post") {
//                    postViewModel.submitPost(postAuthorMap: authenticationViewModel.getPostAuthorMap())
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        postViewModel.shouldPopToRootViewIfFalse = false
//                        tabViewModel.tabSelection = 1
//                    }
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }
                
                Button(action: {
                    postViewModel.submitPost(postAuthorMap: authenticationViewModel.getPostAuthorMap())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        postViewModel.shouldPopToRootViewIfFalse = false
//                    TODO: pop Home to root view also
                        tabViewModel.tabSelection = 1
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    HStack {
                        if (postViewModel.isSubmitting) {
                            Text("Loading...")
                                .font(Font.custom(Constants.bodyFont, size: 16))
                        } else {
                            Text("Post")
                                .font(Font.custom(Constants.bodyFont, size: 16))
                        }
                    }.padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(self.postViewModel.isSubmitting || self.postViewModel.postTitle.isEmpty || self.postViewModel.postBody.isEmpty)
            }
        }
    }
}

//struct AddPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPostView(homeViewModel: <#T##HomeViewModel#>, authenticationViewModel: <#T##AuthenticationViewModel#>, pickerResult: <#T##Binding<UIImage>#>)
//    }
//}
