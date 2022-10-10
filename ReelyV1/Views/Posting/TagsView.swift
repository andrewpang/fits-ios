//
//  TagsView.swift
//  FITs
//
//  Created by Andrew Pang on 10/7/22.
//

import SwiftUI

struct TagsView: View {
    
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Spacer()
                ForEach(postViewModel.hardcodedTags, id: \.self) { tagTitle in
                    TagView(title: tagTitle, isSelected: false, postViewModel: postViewModel)
                }
                Spacer()
            }
        }.onTapGesture { // Hacky fix for nested clicks to work
        }
//        .frame(height: 40)
    }
}

struct TagView: View {
    let title: String
    @State var isSelected: Bool
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        HStack {
            Text("#" + title)
                .font(Font.custom(Constants.bodyFont, size: 16))
                .lineLimit(1)
        }.padding(.horizontal, 12)
        .padding(.vertical, 4)
        .foregroundColor(isSelected ? .white : .gray)
        .background(isSelected ? Color.black : Color.white)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(isSelected ? Color.black: Color.gray, lineWidth: 1.0)
        ).padding(.vertical, 2)
        .onTapGesture {
            isSelected.toggle()
            if (isSelected) {
                postViewModel.postTags?.append(title)
            } else {
                postViewModel.postTags?.removeAll(where: { $0 == title })
            }
        }
    }
}
