//
//  ContentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {

        TabView {
            HomeView()
             .tabItem {
                Image(systemName: "house")
                Text("Home")
              }
            AddPostView()
             .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Post")
              }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
