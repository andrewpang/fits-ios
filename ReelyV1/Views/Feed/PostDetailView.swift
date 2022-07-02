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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                VStack(alignment: .leading) {
//                    HStack {
//                        Text(post.productName + " by " + post.brandName).font(Font.system(size: 20)).bold()
//                        Spacer()
//                        Image(systemName: "heart").foregroundColor(.black)
//                    }
//                    Text("📸 Posted by: " + post.author).foregroundColor(.gray)
//                    Text("🏷 Price: " + post.price).foregroundColor(.gray)
//                    Text(post.body).padding(.top)
                }.padding()
            }
        }
    }
}

//struct PostDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetailView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
//    }
//}
