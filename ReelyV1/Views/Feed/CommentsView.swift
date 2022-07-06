//
//  CommentsView.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/5/22.
//

import SwiftUI

struct CommentsView: View {
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    
    var body: some View {
        Text("Comments").font(Font.system(size: 20)).bold().padding(.vertical, 0)
        if let commentModels = postDetailViewModel.commentsData.commentModels, !commentModels.isEmpty {
            VStack(spacing: 0) {
                ForEach(commentModels, id: \.id) { comment in
                    CommentRowView(commentModel: comment).padding(.vertical, 8)
                }
            }
        } else {
            Text("Be the first to add a comment").font(Font.system(size: 16)).foregroundColor(.gray)
        }
    }
}

//struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView(postDetailViewModel: PostDetailViewModel(postModel: PostModel(from: <#Decoder#>)))
//    }
//}
