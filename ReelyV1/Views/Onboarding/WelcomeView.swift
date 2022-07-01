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
                Color.gray.opacity(0.75)
                    .ignoresSafeArea()
                VStack {
                    Text("FIT(s)").font(Font.system(size: 60)).foregroundColor(.white)
                    Spacer()
                    Text("Subtitle").font(Font.system(size: 24)).foregroundColor(.white)
                    Text("Subtitle").font(Font.system(size: 24)).foregroundColor(.white)
                    Text("Subtitle").font(Font.system(size: 24)).foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: ValuePropView()) {
                        HStack {
                            Text("Get Started")
                                .font(.headline)
                            Image(systemName: "chevron.right.circle")
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
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
