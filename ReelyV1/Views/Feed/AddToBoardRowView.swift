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
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: previewImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
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
                Text(bookmarkBoardModel.title ?? "Collection")
                    .font(Font.custom(Constants.titleFontBold, size: 18))
                    .padding(.horizontal, 8)
                    .foregroundColor(Color(Constants.darkBackgroundColor))
                Spacer()
                if (alreadyAddedToBoard) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(Constants.darkBackgroundColor))
                }
            }.padding(.horizontal, 24)
        }
    }
}
