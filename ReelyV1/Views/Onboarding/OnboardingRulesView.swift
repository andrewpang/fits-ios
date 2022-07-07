//
//  OnboardingRulesView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/30/22.
//

import SwiftUI

struct OnboardingRulesView: View {
    var body: some View {
        ZStack {
//            Color.black
//                .ignoresSafeArea()
        
            VStack {
                Image("RulesFIT")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 400)
                Spacer()
                NavigationLink(destination: SetNameOnboardingView(authenticationViewModel: AuthenticationViewModel())) {
                    HStack {
                        Text("Accept")
                            .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    .background(Constants.buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(Constants.buttonCornerRadius)
                    .padding(.horizontal, 40)
                    .padding(.top, 24)
                }
            }.padding(24)
        }
    }
}

struct OnboardingRulesView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRulesView()
    }
}
