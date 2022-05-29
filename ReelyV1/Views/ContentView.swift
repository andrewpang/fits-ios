//
//  ContentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            if (Auth.auth().currentUser == nil) {
                SignUpView()
            } else {
                SignedInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
