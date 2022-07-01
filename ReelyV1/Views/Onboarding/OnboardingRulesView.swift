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
            ZStack(alignment: .leading) {
                Image("paperBackground")
                VStack {
                    Image("placeHolder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("FIT(s) Rules").font(Font.system(size: 24)).bold().foregroundColor(.black)
                    HStack {
                        Text("1. FIT only.").font(Font.system(size: 16)).foregroundColor(.black)
                        Spacer()
                    }
                    HStack {
                        Text("2. Stay authentic. No sponsored & branded content posts.").font(Font.system(size: 16)).foregroundColor(.black)
                        Spacer()
                    }
                    HStack {
                        Text("3. Be inclusive").font(Font.system(size: 16)).foregroundColor(.black)
                        Spacer()
                    }
                    Spacer()
                }.padding(24)
            }.padding(.bottom, 24)
            Spacer()
            NavigationLink(destination: EditProfileView(authenticationViewModel: AuthenticationViewModel())) {
                HStack {
                    Text("Accept")
                        .font(.headline)
                    Image(systemName: "checkmark.square")
                        .font(.system(size: 20))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }.padding(24)
    }
}

struct OnboardingRulesView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRulesView()
    }
}
