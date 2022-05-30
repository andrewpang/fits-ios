//
//  SignUpView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel()
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Email:")
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Password:")
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            NavigationLink(destination: TabsParentView().navigationBarBackButtonHidden(true),
                               label: {
                Text("Sign Up")
                    .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }).padding(.top, 40)
        }.padding()
        .navigationTitle("Sign Up")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
