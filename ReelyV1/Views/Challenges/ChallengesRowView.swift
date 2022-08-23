//
//  ChallengesRowView.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import SwiftUI

struct ChallengesRowView: View {
    
    @State var challengeModel: ChallengeModel
    @State var isBlurred = true
    
    var body: some View {
        VStack(spacing: 0){
            Text("\(challengeModel.title)")
                .font(Font.custom(Constants.titleFontBold, size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(Constants.backgroundColor))
                .padding(.top, 24)
                .padding(.bottom, 16)
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Rectangle().fill(Color.gray)
                        .aspectRatio(1.0, contentMode: .fill)
                        .cornerRadius(Constants.buttonCornerRadius)
                    Rectangle().fill(Color.gray)
                        .aspectRatio(1.0, contentMode: .fill)
                        .cornerRadius(Constants.buttonCornerRadius)
                }
                HStack(spacing: 8) {
                    Rectangle().fill(Color.gray)
                        .aspectRatio(1.0, contentMode: .fill)
                        .cornerRadius(Constants.buttonCornerRadius)
                    Rectangle().fill(Color.gray)
                        .aspectRatio(1.0, contentMode: .fill)
                        .cornerRadius(Constants.buttonCornerRadius)
                }
            }.padding(8)
            .aspectRatio(contentMode: .fit)
            .blur(radius: getBlurRadius())
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
