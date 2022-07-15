//
//  WelcomeView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/30/22.
//

import SwiftUI
import AVKit
import Amplitude

struct WelcomeView: View {
    let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    var player = AVPlayer()
    let videoName = "pexels-runway"
    
    var body: some View {
        NavigationView {
            VStack(alignment:.center) {
                Text("FIT(s)")
                    .font(Font.custom(Constants.titleFont, size: 80))
                    .foregroundColor(.white)
                Spacer()
                Text("Share & Discover the Latest Fashion at the Fashion Institute of Technology")
                    .font(Font.custom(Constants.bodyFont, size: 18))
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                NavigationLink(destination: OnboardingRulesView()) {
                    HStack {
                        Text("Get Started")
                            .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    .background(Color(Constants.onBoardingButtonColor))
                    .cornerRadius(Constants.buttonCornerRadius)
                    .padding(.horizontal, 40)
                    .padding(.top, 40)
                    .padding(.bottom, Constants.onboardingButtonBottomPadding)
                }
            }
            .background(
                ZStack {
                    Image("WelcomeFirstFrame")
                        .edgesIgnoringSafeArea(.all)
                    WelcomeVideoPlayerView()
                        .edgesIgnoringSafeArea(.all)
                }
            )
        }.onAppear {
            Amplitude.instance().logEvent("Welcome Screen - View")
//            for family in UIFont.familyNames {
//                 print(family)
//
//                 for names in UIFont.fontNames(forFamilyName: family){
//                 print("== \(names)")
//                 }
//            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
