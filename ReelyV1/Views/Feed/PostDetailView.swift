//
//  PostDetailView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/28/22.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    var post: PostModel
    
    @State var commentText = ""
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    KFImage(URL(string: post.imageUrl))
                        .resizable()
                        .scaledToFill()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(post.title).font(Font.system(size: 20)).bold()
                            Spacer()
                            Image(systemName: "heart").foregroundColor(.black)
                        }
                        Text("📸 Posted by: " + (post.author.displayName ?? "Name")).foregroundColor(.gray)
                        Text(post.body).padding(.top)
                    }.padding()
                }
            }.onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
            Divider()
            HStack {
                if let profilePicImageUrl = authenticationViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: profilePicImageUrl))
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 32)
                        .clipShape(Circle())
                        .padding(.leading, 8)
                } else {
                    Image("portraitPlaceHolder")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 32)
                        .clipShape(Circle())
                        .padding(.leading, 8)
                }
                if #available(iOS 15.0, *) {
                    TextField("Add Comment", text: $commentText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 16)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.send)
                } else {
                    // Fallback on earlier versions
                    TextField("Add Comment", text: $commentText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 16)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                if (!commentText.isEmpty) {
                    Image(systemName: "arrow.up.circle")
                        .font(.system(size: 32.0))
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }.background(Color.white)
        }
    }
}

//struct PostDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetailView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
//    }
//}
