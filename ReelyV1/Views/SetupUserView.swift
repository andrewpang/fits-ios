//
//  SetupUserView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/30/22.
//

import SwiftUI

struct SetupUserView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State var username: String = ""
    
    var body: some View {
        VStack {
            Text("Upload a profile picture (optional)")
            Text("Select a username (required):")
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button(action: {
//                authenticationViewModel.state = .signedIn
            }, label: {
                Text("Continue")
                    .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }).padding(.top, 40)
        }.padding()
        .navigationTitle("Profile")
    }
}

struct SetupUserView_Previews: PreviewProvider {
    static var previews: some View {
        SetupUserView(authenticationViewModel: AuthenticationViewModel())
    }
}
