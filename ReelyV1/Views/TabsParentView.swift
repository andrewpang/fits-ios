//
//  TabsParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import SwiftUI

struct TabsParentView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $homeViewModel.tabSelection) {
            GalleryFeedView(homeViewModel: homeViewModel)
             .tabItem {
                Image(systemName: "house")
                Text("Home")
              }.tag(1)
            PostParentView(homeViewModel: homeViewModel)
             .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Post")
              }.tag(2)
        }
        .onChange(of: homeViewModel.tabSelection, perform: { index in
            homeViewModel.fetchPosts()
        })
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        TabsParentView()
    }
}
