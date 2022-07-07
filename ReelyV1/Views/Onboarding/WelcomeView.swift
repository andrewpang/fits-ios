//
//  WelcomeView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/30/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("FITBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                Color.gray.opacity(0.25)
                    .ignoresSafeArea()
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
                    NavigationLink(destination: OnboardingRulesView()) {
                        HStack {
                            Text("Get Started")
                                .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                .foregroundColor(.black)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                        .background(Constants.buttonColor)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .padding(.horizontal, 40)
                        .padding(.top, 40)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 120)
            }
        }.onAppear {
            for family in UIFont.familyNames {
                 print(family)

                 for names in UIFont.fontNames(forFamilyName: family){
                 print("== \(names)")
                 }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
