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
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            ZStack {
//                VStack(spacing: Constants.promptImageSpacing) {
//                    HStack(spacing: Constants.promptImageSpacing) {
//                        if (promptModel.previewImageUrls?.count ?? 0 > 1) {
//                            if let imageUrl = promptModel.previewImageUrls?[0] {
//                                KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)))
//                                    .resizable()
//                                    .aspectRatio(1.0, contentMode: .fit)
//                                    .cornerRadius(Constants.promptImageCornerRadius)
//                            }
//                        } else {
//                            Rectangle().fill(Color.gray)
//                                .aspectRatio(1.0, contentMode: .fill)
//                                .cornerRadius(Constants.promptImageCornerRadius)
//                        }
//
//                        Rectangle().fill(Color.gray)
//                            .aspectRatio(1.0, contentMode: .fill)
//                            .cornerRadius(Constants.promptImageCornerRadius)
//                    }
//                    HStack(spacing: Constants.promptImageSpacing) {
//                        Rectangle().fill(Color.gray)
//                            .aspectRatio(1.0, contentMode: .fill)
//                            .cornerRadius(Constants.promptImageCornerRadius)
//                        Rectangle().fill(Color.gray)
//                            .aspectRatio(1.0, contentMode: .fill)
//                            .cornerRadius(Constants.promptImageCornerRadius)
//                    }
//                }.padding(Constants.promptImageSpacing)
//                .aspectRatio(contentMode: .fit)
//                .blur(radius: getBlurRadius())
                
                HStack(spacing: Constants.promptImageSpacing) {
                    if (promptModel.previewImageUrls?.count ?? 0 > 0) {
                        if let imageUrl = promptModel.previewImageUrls?[0] {
                            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)))
                                .resizable()
                                .aspectRatio(0.666, contentMode: .fit)
                                .cornerRadius(Constants.promptImageCornerRadius)
                        }
                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(0.666, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    if (promptModel.previewImageUrls?.count ?? 0 > 1) {
                        if let imageUrl = promptModel.previewImageUrls?[1] {
                            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)))
                                .resizable()
                                .aspectRatio(0.666, contentMode: .fit)
                                .cornerRadius(Constants.promptImageCornerRadius)
                        }
                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(0.666, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    if (promptModel.previewImageUrls?.count ?? 0 > 2) {
                        if let imageUrl = promptModel.previewImageUrls?[2] {
                            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)))
                                .resizable()
                                .aspectRatio(0.666, contentMode: .fit)
                                .cornerRadius(Constants.promptImageCornerRadius)
                        }
                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(0.666, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    if (promptModel.previewImageUrls?.count ?? 0 > 3) {
                        if let imageUrl = promptModel.previewImageUrls?[3] {
                            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)))
                                .resizable()
                                .aspectRatio(0.666, contentMode: .fit)
                                .cornerRadius(Constants.promptImageCornerRadius)
                        }
                    } else {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(0.666, contentMode: .fit)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                }.blur(radius: getBlurRadius())
                .padding(Constants.promptImageSpacing)
                if (!promptsViewModel.hasCurrentUserPostedToPrompt(with: promptModel.id) && !promptModel.promptHasAlreadyEnded()) {
                    VStack {
//                        Text("🙈")
//                            .font(.system(size: 40))
                        Image(systemName: "eye.slash")
                            .font(.system(size: 24.0))
                            .foregroundColor(Color(Constants.backgroundColor))
                            .padding(.vertical, 8)
//                        Text("Participate to View")
//                            .font(Font.custom(Constants.bodyFont, size: 16))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color(Constants.backgroundColor))
//                        Button(action: {
//                            //
//                        }) {
                            HStack {
                                Text("Participate to View")
                                    .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                    .foregroundColor(Color(Constants.backgroundColor))
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55)
                            .background(Color("FITColor"))
                            .cornerRadius(Constants.buttonCornerRadius)
                            .padding(.horizontal, 60)
//                        }
                    }
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
