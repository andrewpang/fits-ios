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
            Image("RulesFIT")
                .resizable()
                .scaledToFill()
                .frame(height: 400)
            Spacer()
            NavigationLink(destination: EditProfileView(authenticationViewModel: AuthenticationViewModel())) {
                HStack {
                    Text("Accept")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(Color("LightGray"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 40)
                .padding(.top, 24)
            }
        }.padding(24)
    }
}

struct OnboardingRulesView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRulesView()
    }
}
