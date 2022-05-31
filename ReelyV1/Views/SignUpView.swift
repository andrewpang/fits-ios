//
//  SignUpView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("Email:").bold().padding(.top, 32)
                Text("This is what you will use to login (required)").font(Font.system(size: 14)).foregroundColor(.gray)
                TextField("Email", text: $authenticationViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Password:").bold()
                SecureField("Password", text: $authenticationViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                NavigationLink(destination: SetupUserView(authenticationViewModel: authenticationViewModel),
                                   label: {
                    Text("Continue")
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
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authenticationViewModel: AuthenticationViewModel())
    }
}
