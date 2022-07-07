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
                Color.gray.opacity(0.95)
                    .ignoresSafeArea()
                VStack(alignment:.center) {
                    Text("FIT(s)")
                        .font(Font.system(size: 80))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Share & Discover the Latest Fashion at the Fashion Institute of Technology")
                        .font(Font.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    NavigationLink(destination: ValuePropView()) {
                        HStack {
                            Text("Get Started")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                        .background(Color("LightGray"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                        .padding(.top, 40)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 120)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
