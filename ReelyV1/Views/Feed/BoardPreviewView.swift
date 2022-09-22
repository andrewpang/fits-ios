//
//  BoardPreviewView.swift
//  FITs
//
//  Created by Andrew Pang on 9/22/22.
//

import SwiftUI
import Kingfisher

struct BoardPreviewView: View {
    
    @State var firstImageUrl: String
    
    var body: some View {
        HStack(spacing:0) {
            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: firstImageUrl, width: CloudinaryHelper.thumbnailWidth)))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 151)
                .clipped()
                .cornerRadius(Constants.buttonCornerRadius, corners: [.topLeft, .bottomLeft])
            Divider()
                .frame(width: 1, height: 151)
                .overlay(.white)
            VStack(spacing:0){
                Rectangle().fill(Color(Constants.onBoardingButtonColor))
                    .frame(width: 100, height: 75)
                    .cornerRadius(Constants.buttonCornerRadius, corners: [.topRight])
                Divider()
                    .frame(width: 100, height: 1)
                    .overlay(.white)
                Rectangle().fill(Color(Constants.onBoardingButtonColor))
                    .frame(width: 100, height: 75)
                    .cornerRadius(Constants.buttonCornerRadius, corners: [.bottomRight])
            }
        }
    }
}
