//
//  AddToBoardRowView.swift
//  FITs
//
//  Created by Andrew Pang on 9/23/22.
//

import SwiftUI
import Kingfisher

struct AddToBoardRowView: View {
    
    @State var bookmarkBoardModel: BookmarkBoardModel
    @State var alreadyAddedToBoard = false
    
    var body: some View {
        VStack {
            HStack {
                if let previewImageUrl = bookmarkBoardModel.previewImageUrl {
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: previewImageUrl, width: CloudinaryHelper.thumbnailWidth)))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .clipped()
                } else {
                    Image("placeHolder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
                        .cornerRadius(Constants.promptImageCornerRadius)
                        .clipped()
                }
                Text(bookmarkBoardModel.title ?? "Board")
                    .font(Font.custom(Constants.bodyFont, size: 18))
                    .padding(.horizontal, 8)
                    .foregroundColor(Color(Constants.darkBackgroundColor))
                Spacer()
                if (alreadyAddedToBoard) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32.0, weight: .light))
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 32.0, weight: .light))
                        .foregroundColor(Color(Constants.darkBackgroundColor))
                }
            }.padding(.horizontal, 24)
//            Divider()
//                .frame(height: 1)
//                .overlay(Color(Constants.darkBackgroundColor))
        }
    }
}
