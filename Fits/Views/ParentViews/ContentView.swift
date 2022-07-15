//
//  ContentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel()
    
    var body: some View {

        ZStack {
            if (authenticationViewModel.state == .signedIn) {
                TabsParentView()
            }
            if (authenticationViewModel.state == .signedOut) {
                WelcomeView()
            }
            if (authenticationViewModel.state == .loading) {
                LoadingSplashScreenView()
            }
        }.environmentObject(authenticationViewModel)
        .onAppear {
            authenticationViewModel.checkIfSignedIn()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
