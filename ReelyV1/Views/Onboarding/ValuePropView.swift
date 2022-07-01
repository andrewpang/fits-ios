//
//  ValuePropView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/30/22.
//

import SwiftUI

struct ValuePropView: View {
    var body: some View {
        VStack {
            Text("Value Proposition").font(Font.system(size: 60)).foregroundColor(.black)
            Spacer()
            Text("Text").font(Font.system(size: 24)).foregroundColor(.black)
            Text("Text").font(Font.system(size: 24)).foregroundColor(.black)
            Text("Text").font(Font.system(size: 24)).foregroundColor(.black)
            Spacer()
            NavigationLink(destination: OnboardingRulesView()) {
                HStack {
                    Text("Continue")
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

struct ValuePropView_Previews: PreviewProvider {
    static var previews: some View {
        ValuePropView()
    }
}
