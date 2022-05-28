//
//  ContentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView()
             .tabItem {
                Image(systemName: "house")
                Text("Home")
              }.tag(1)
            PostParentView(tabSelection: $tabSelection)
             .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Post")
              }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
