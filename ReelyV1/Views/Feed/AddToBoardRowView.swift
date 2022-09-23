//
//  AddToBoardRowView.swift
//  FITs
//
//  Created by Andrew Pang on 9/23/22.
//

import SwiftUI

struct AddToBoardRowView: View {
    
    @State var bookmarkBoardModel: BookmarkBoardModel
    @State var alreadyAddedToBoard = false
    
    var body: some View {
        VStack {
            HStack {
//                if let profilePicImageUrl = likeModel.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
//                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.thumbnailWidth)))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
//                        .clipShape(Circle())
//                } else {
//                    Image("portraitPlaceHolder")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
//                        .clipShape(Circle())
//                }
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
            Divider()
                .frame(height: 1)
                .overlay(Color(Constants.darkBackgroundColor))
        }
    }
}
