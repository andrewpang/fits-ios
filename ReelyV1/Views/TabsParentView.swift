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
    
    var body: some View {
        TabView(selection: $tabViewModel.tabSelection) {
            GalleryFeedView()
             .tabItem {
                Image(systemName: "house")
                Text("Home")
              }.tag(homeIndex)
            PostParentView()
             .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Post")
              }.tag(2)
            MyProfileView()
             .tabItem {
                Image(systemName: "person")
                Text("Profile")
              }.tag(3)
        }
        .environmentObject(tabViewModel)
        .onChange(of: tabViewModel.tabSelection, perform: { index in
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
