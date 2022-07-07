//
//  MyProfileView.swift
//  FITs
//
//  Created by Andrew Pang on 7/7/22.
//

import SwiftUI

struct MyProfileView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        Button(action: {
            authenticationViewModel.signOut()
        }, label: {
            Text("Sign Out")
        })
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
