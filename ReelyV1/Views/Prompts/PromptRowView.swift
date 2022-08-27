//
//  PromptRowView.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import SwiftUI
import Firebase
import Kingfisher

struct PromptRowView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var promptsViewModel: PromptsViewModel
    @State var promptModel: PromptModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text(promptModel.title ?? "")
                .font(Font.custom(Constants.titleFontBold, size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(Constants.backgroundColor))
                .padding(.top, 24)
                .padding(.horizontal, 16)
            if let endTimeString = promptModel.getFormattedDateString() {
                Text("Ends: \(endTimeString)")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
            }
            ZStack {
                HStack(spacing: Constants.promptImageSpacing) {
                    if let previewImageUrls = promptModel.previewImageUrls, previewImageUrls.count >= 1 {
                        KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: previewImageUrls[previewImageUrls.count - 1], width: CloudinaryHelper.thumbnailWidth)))
                            .resizable()
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    if let previewImageUrls = promptModel.previewImageUrls, previewImageUrls.count >= 2 {
                        KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: previewImageUrls[previewImageUrls.count - 2], width: CloudinaryHelper.thumbnailWidth)))
                            .resizable()
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)

                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    if let previewImageUrls = promptModel.previewImageUrls, previewImageUrls.count >= 3 {
                        KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: previewImageUrls[previewImageUrls.count - 3], width: CloudinaryHelper.thumbnailWidth)))
                            .resizable()
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)

                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    if let previewImageUrls = promptModel.previewImageUrls, previewImageUrls.count >= 4 {
                        KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: previewImageUrls[previewImageUrls.count - 4], width: CloudinaryHelper.thumbnailWidth)))
                            .resizable()
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)

                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(Constants.promptPreviewImageAspectRatio, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                }.blur(radius: getBlurRadius())
                .padding(Constants.promptImageSpacing)
                if (!promptsViewModel.hasCurrentUserPostedToPrompt(with: promptModel.id) && !promptModel.promptHasAlreadyEnded()) {
                    VStack {
//                        Text("🙈")
//                            .font(.system(size: 40))
                       
//                        Text("Participate to View")
//                            .font(Font.custom(Constants.bodyFont, size: 16))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color(Constants.backgroundColor))
//                        Button(action: {
//                            //
//                        }) {
                        HStack {
                            Image(systemName: "eye.slash")
                                .font(.system(size: 20.0))
                                .foregroundColor(Color(Constants.backgroundColor))
                            Text("Participate to View")
                                .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                .foregroundColor(Color(Constants.backgroundColor))
                                .padding(.vertical, 16)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55)
                        .background(Color("FITColor"))
                        .cornerRadius(Constants.buttonCornerRadius)
                        .padding(.horizontal, 40)
                    }.padding(.vertical, 8)
                }
            }
        }.background(Color(Constants.darkBackgroundColor))
        .cornerRadius(Constants.buttonCornerRadius)        
    }
    
    func getBlurRadius() -> CGFloat {
        if (!promptsViewModel.hasCurrentUserPostedToPrompt(with: promptModel.id) && !promptModel.promptHasAlreadyEnded()) {
            return 10
        } else {
            return 0
        }
    }
}
