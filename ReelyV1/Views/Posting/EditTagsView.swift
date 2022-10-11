//
//  EditTagsView.swift
//  FITs
//
//  Created by Andrew Pang on 10/10/22.
//

import SwiftUI

struct EditTagsView: View {
    
    @Binding var editPostTags: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Spacer()
                ForEach(PostViewModel.hardcodedTags, id: \.self) { tagTitle in
                    EditTagView(title: tagTitle, editPostTags: $editPostTags)
                }
                Spacer()
            }
        }.onTapGesture { // Hacky fix for nested clicks to work
        }
//        .frame(height: 40)
    }
}

struct EditTagView: View {
    let title: String
    @State var isSelected: Bool = false
    @Binding var editPostTags: [String]
    
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
                editPostTags.append(title)
            } else {
                editPostTags.removeAll(where: { $0 == title })
            }
        }.onAppear {
            if (editPostTags.contains(title)) {
                isSelected = true
            } else {
                isSelected = false
            }
        }
    }
}

