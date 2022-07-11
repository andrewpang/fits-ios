//
//  TabsParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import SwiftUI

let homeIndex = 1

struct TabsParentView: View {
    @StateObject var tabViewModel: TabViewModel = TabViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $tabViewModel.tabSelection) {
            GalleryFeedView(homeViewModel: homeViewModel)
             .tabItem {
                Image(systemName: "house")
                Text("Home")
              }.tag(homeIndex)
            PostParentView(homeViewModel: homeViewModel)
             .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Post")
              }.tag(2)
            ProfileParentView()
             .tabItem {
                Image(systemName: "person")
                Text("Profile")
              }.tag(3)
        }
        .environmentObject(tabViewModel)
        .onChange(of: tabViewModel.tabSelection, perform: { index in
//            TODO: We need this so that it fetches after posting, but now there are times where it'll fetch twice
//            if (index == homeIndex) {
//                homeViewModel.fetchPosts()
//            }
        })
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        TabsParentView()
    }
}
