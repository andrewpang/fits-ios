//
//  CollectionsProfileRowView.swift
//  FITs
//
//  Created by Andrew Pang on 9/26/22.
//

import SwiftUI
import Kingfisher

struct CollectionsProfileRowView: View {
    
    @State var bookmarkBoardModel: BookmarkBoardModel
    
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
                Text(bookmarkBoardModel.title ?? "Board")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 8)
                    .foregroundColor(Color(Constants.darkBackgroundColor))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.gray)
            }.padding(.horizontal, 24)
        }
    }
}
