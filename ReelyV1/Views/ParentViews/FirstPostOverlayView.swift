//
//  FirstPostOverlayView.swift
//  FITs
//
//  Created by Andrew Pang on 7/12/22.
//

import SwiftUI

struct FirstPostOverlayView: View {
    var body: some View {
        ZStack {
            Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.75)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Welcome to FIT(s)!")
                    .font(Font.custom(Constants.titleFont, size: 32))
                    .bold()
                    .multilineTextAlignment(.center)
                Text("Let’s help you make your **first post** so you can introduce yourself to your fellow FIT classmates.")
                    .font(Font.custom(Constants.bodyFont, size: 18))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                Spacer()
                Image("placeHolder")
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 200, height: 200)
                    .frame(maxHeight: 200)
                    .cornerRadius(Constants.buttonCornerRadius)
                Spacer()
                Text("Step 1: Choose a picture of yourself you’d like to share")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
                NavigationLink(destination: EmptyView()) {
                    HStack {
                        Text("Choose Photo")
                            .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    .background(Color(Constants.onBoardingButtonColor))
                    .foregroundColor(.white)
                    .cornerRadius(Constants.buttonCornerRadius)
                    .padding(.horizontal, 40)
                }
                Text("Skip for now")
                    .font(Font.custom(Constants.bodyFont, size: 14))
                    .foregroundColor(.gray)
            }.padding(.horizontal, 24)
            .padding(.vertical, 40)
            .background(RoundedRectangle(cornerRadius: 27).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color.black.opacity(0.1), lineWidth: 2))
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
                
                
        }
    }
}

struct FirstPostOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPostOverlayView()
    }
}
