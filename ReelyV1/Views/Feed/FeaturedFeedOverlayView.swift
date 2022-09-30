//
//  FeaturedFeedOverlayView.swift
//  FITs
//
//  Created by Andrew Pang on 9/30/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel

struct FeaturedFeedOverlayView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    @State var showPicker = false
    @State var showConfirmationDialog = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        ZStack {
            Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.75)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    homeViewModel.showFeaturedFeedOverlay = false
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Color.black)
                    }
                })
                .padding(.horizontal, 24)
                Text("Featured Posts")
                    .font(Font.custom(Constants.titleFont, size: 32))
                    .foregroundColor(Color.black)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 24)
                Text("Every Sunday, 10 of the most informative posts of the last week will be featured to the community")
                    .font(Font.custom(Constants.bodyFont, size: 18))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                KFAnimatedImage(URL(string: Constants.featuredPostGifUrl))
                    .scaledToFit()
                    .cornerRadius(Constants.buttonCornerRadius)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
//                    Spacer()
                Text("To be featured, make sure your write an informative review on your outfit that is helpful to others")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Button(action: {
                    homeViewModel.showFeaturedFeedOverlay = false
                }, label: {
                    HStack {
                        Text("Got It!")
                            .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    .background(Color(Constants.onBoardingButtonColor))
                    .foregroundColor(.white)
                    .cornerRadius(Constants.buttonCornerRadius)
                    .padding(.horizontal, 40)
                })
                .padding(.vertical, 8)
//                    Button(action: {
//                        homeViewModel.showFeaturedFeedOverlay = false
//                    }, label: {
//                        Text("Dismiss")
//                            .font(Font.custom(Constants.bodyFont, size: 14))
//                            .foregroundColor(.gray)
//                    })
            }
            .padding(.vertical, 24)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
    }
}
