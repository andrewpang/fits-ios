//
//  SMSSignUpView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/27/22.
//

import SwiftUI
//import iPhoneNumberField

struct SMSSignUpView: View {
    @State var phoneNumber = ""
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.purple.ignoresSafeArea()
                VStack {
                    Text("What is your phone number?")
                    Text("We will not text you")
//                    iPhoneNumberField("(000) 000-0000", text: $phoneNumber, isEditing: $isEditing)
//                        .flagHidden(false)
//                        .flagSelectable(true)
//                        .font(UIFont(size: 24, weight: .light, design: .monospaced))
//                        .maximumDigits(10)
//                        .foregroundColor(Color.black)
//                        .placeholderColor(Color.gray)
//                        .clearButtonMode(.whileEditing)
//                        .onClear { _ in phoneNumber = "" }
//                        .onReturn { _ in isEditing.toggle() }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(color: isEditing ? .gray : .white, radius: 10)
//                        .padding()
                    
                    NavigationLink(destination: SMSConfirmationView(),
                                       label: {
                        Text("Confirm")
                        })
                }
            }
        }
    }
}

struct SMSSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SMSSignUpView()
    }
}
