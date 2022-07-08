//
//  OnboardingRulesView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/30/22.
//

import SwiftUI

struct OnboardingRulesView: View {
    var body: some View {
        VStack {
            Spacer()
            NavigationLink(destination: SetNameOnboardingView(authenticationViewModel: AuthenticationViewModel())) {
                HStack {
                    Text("Accept")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(.black)
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
                .padding(.bottom, Constants.onboardingButtonBottomPadding)
            }
        }
        .background(
            Image("RulesFIT")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct OnboardingRulesView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRulesView()
    }
}
