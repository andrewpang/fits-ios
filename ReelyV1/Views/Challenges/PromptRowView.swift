//
//  PromptRowView.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import SwiftUI

struct PromptRowView: View {
    
    @State var promptModel: PromptModel
    @State var isBlurred = true
    
    var body: some View {
        VStack(spacing: 0){
            Text(promptModel.title)
                .font(Font.custom(Constants.titleFontBold, size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(Constants.backgroundColor))
                .padding(.top, 24)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            ZStack {
                VStack(spacing: Constants.promptImageSpacing) {
                    HStack(spacing: Constants.promptImageSpacing) {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(1.0, contentMode: .fill)
                            .cornerRadius(Constants.promptImageCornerRadius)
                        Rectangle().fill(Color.gray)
                            .aspectRatio(1.0, contentMode: .fill)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                    HStack(spacing: Constants.promptImageSpacing) {
                        Rectangle().fill(Color.gray)
                            .aspectRatio(1.0, contentMode: .fill)
                            .cornerRadius(Constants.promptImageCornerRadius)
                        Rectangle().fill(Color.gray)
                            .aspectRatio(1.0, contentMode: .fill)
                            .cornerRadius(Constants.promptImageCornerRadius)
                    }
                }.padding(Constants.promptImageSpacing)
                .aspectRatio(contentMode: .fit)
                .blur(radius: getBlurRadius())
                if (isBlurred) {
                    VStack {
//                        Text("🙈")
//                            .font(.system(size: 40))
                        Image(systemName: "eye.slash")
                            .font(.system(size: 32.0))
                            .foregroundColor(Color(Constants.backgroundColor))
                        Text("Participate to View")
                            .font(Font.custom(Constants.bodyFont, size: 28))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(Constants.backgroundColor))
//                        Button(action: {
//                            //
//                        }) {
                            HStack {
                                Text("Post a Fit")
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
        if (isBlurred) {
            return 10
        } else {
            return 0
        }
    }
}
