//
//  PostTagsView.swift
//  FITs
//
//  Created by Andrew Pang on 10/10/22.
//

import SwiftUI

struct PostTagsView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Spacer()
                if let tags = postDetailViewModel.postModel.tags?.filter({ !postDetailViewModel.postTypeTags.contains($0) }) {
                    ForEach(tags, id: \.self) { tagTitle in
                        if (tags[0] == tagTitle) {
                            PostTagView(title: tagTitle).padding(.leading, 8)
                        } else {
                            PostTagView(title: tagTitle)
                        }
//                        }
                    }
                }
                Spacer()
            }
        }.onTapGesture { // Hacky fix for nested clicks to work
        }
//        .frame(height: 40)
    }
}

struct PostTagView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text("#" + title)
                .font(Font.custom(Constants.bodyFont, size: 16))
                .lineLimit(1)
        }.padding(.horizontal, 12)
        .padding(.vertical, 4)
        .foregroundColor(.black)
        .background(Color.white)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black, lineWidth: 1.0)
        ).padding(.vertical, 2)
    }
}
